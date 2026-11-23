require 'spec_helper'
require 'open3'

describe Bootstrap::Generators::StimulusGenerator do
  let(:controller) { "app/javascript/controllers/bootstrap_controller.js" }

  before { write_destination("app/javascript/controllers/index.js", %{eagerLoadControllersFrom("controllers", application)\n}) }

  it "writes a controller that sets up and tears down Bootstrap components" do
    run_generator(described_class)
    js = read_destination(controller)

    expect(js).to include('import { Controller } from "@hotwired/stimulus"')
    expect(js).to include("connect()").and include("disconnect()")
    expect(js).to include("turbo:before-cache")
    expect(js).to include("Tooltip").and include("Popover")
  end

  it "uses the global Bootstrap from the bundle by default" do
    run_generator(described_class)

    js = read_destination(controller)

    expect(js).to include("window.bootstrap")
    expect(js).not_to include('from "bootstrap"')
  end

  it "imports Bootstrap when it is pinned in the importmap" do
    write_destination("config/importmap.rb", %{pin "bootstrap", to: "twitter/bootstrap/bootstrap.esm.min.js"\n})
    run_generator(described_class)

    js = read_destination(controller)

    expect(js).to include('import * as bootstrap from "bootstrap"')
    expect(js).not_to include("window.bootstrap")
  end

  it "says how to attach it" do
    expect(run_generator(described_class)).to include('data-controller="bootstrap"')
  end

  it "reminds apps that register controllers by hand to update the manifest" do
    write_destination("app/javascript/controllers/index.js", %{application.register("hello", HelloController)\n})

    expect(run_generator(described_class)).to include("stimulus:manifest:update")
  end

  it "refuses an app without Stimulus" do
    FileUtils.rm_rf(destination_path("app/javascript/controllers"))

    expect { run_generator(described_class) }.to raise_error(Rails::Generators::Error, /stimulus-rails/)
  end

  it "writes valid JavaScript in both forms", :if => system("node --version", :out => File::NULL, :err => File::NULL) do
    [false, true].each do |pinned|
      write_destination("config/importmap.rb", pinned ? %{pin "bootstrap"\n} : "")
      run_generator(described_class, %w[--force])
      path = destination_path(controller).sub(/\.js\z/, ".mjs")
      FileUtils.cp(destination_path(controller), path)

      _out, err, status = Open3.capture3("node", "--check", path)
      expect(status).to be_success, err
    end
  end
end
