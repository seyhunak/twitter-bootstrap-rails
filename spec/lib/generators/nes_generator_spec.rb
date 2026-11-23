require 'spec_helper'
require 'json'

describe Bootstrap::Generators::NesGenerator do
  let(:nes) { Twitter::Bootstrap::Rails::BOOTSTRAP_NES }
  let(:alias_spec) { "npm:#{nes[:package]}@#{nes[:version]}" }

  def package_json
    JSON.parse(read_destination("package.json"))
  end

  before do
    stub_rails_application
    write_destination("package.json", JSON.pretty_generate(
      "name" => "app", "dependencies" => { "bootstrap" => "^4.6.2", "jquery" => "^3.7.1" }
    ))
  end

  it "points bootstrap at the NES package, as a dependency and an override" do
    run_generator(described_class)

    expect(package_json["dependencies"]).to include("bootstrap" => alias_spec, "jquery" => "^3.7.1")
    expect(package_json["overrides"]).to eq("bootstrap" => { "." => alias_spec })
  end

  it "adds the registry to .npmrc, reading the token from an environment variable" do
    write_destination(".npmrc", "save-exact=true\n")
    run_generator(described_class)
    npmrc = read_destination(".npmrc")

    expect(npmrc).to include("save-exact=true")
    expect(npmrc).to include("@neverendingsupport:registry=#{nes[:registry]}")
    expect(npmrc).to include("//registry.nes.herodevs.com/npm/pkg/:_authToken=${HERODEVS_NES_TOKEN}")
  end

  it "takes another variable name for the token" do
    run_generator(described_class, %w[--token-env=NES_TOKEN])

    expect(read_destination(".npmrc")).to include(":_authToken=${NES_TOKEN}")
  end

  it "does not repeat itself when run again" do
    run_generator(described_class)
    run_generator(described_class, %w[--force])

    expect(read_destination(".npmrc").scan("@neverendingsupport:registry").size).to eq(1)
  end

  it "keeps an auth line the app already has" do
    write_destination(".npmrc", "//registry.nes.herodevs.com/npm/pkg/:_authToken=${MY_TOKEN}\n")
    run_generator(described_class)

    expect(read_destination(".npmrc").scan("_authToken").size).to eq(1)
  end

  it "records NES mode" do
    run_generator(described_class)

    expect(read_destination("config/initializers/bootstrap.rb")).to include("asset_mode = :nes")
  end

  it "says what to do next, and that the gem's markup is Bootstrap 5" do
    output = run_generator(described_class)

    expect(output).to include("HERODEVS_NES_TOKEN").and include("npm install").and include("jQuery")
    expect(output).to include("Bootstrap 5 markup")
  end

  it "refuses an app without package.json" do
    FileUtils.rm(destination_path("package.json"))

    expect { run_generator(described_class) }.to raise_error(Rails::Generators::Error, /package\.json/)
  end

  describe "the doctor on an NES app" do
    before { run_generator(described_class) }

    def report
      Twitter::Bootstrap::Rails::Doctor.new(destination_root).report
    end

    def check(id)
      report[:checks].find { |c| c[:id] == id }
    end

    it "reports the NES version and distribution" do
      expect(report).to include(:asset_mode => "nes", :bootstrap_version => nes[:bootstrap_version],
                                :bootstrap_distribution => "HeroDevs Bootstrap NES")
    end

    it "is happy with what the generator wrote" do
      expect(check("nes_package")[:status]).to eq("ok")
      expect(check("nes_registry")[:status]).to eq("ok")
    end

    it "reports an error when package.json no longer uses the NES package" do
      write_destination("package.json", JSON.pretty_generate("dependencies" => { "bootstrap" => "^4.6.2" }))

      expect(check("nes_package")).to include(:status => "error", :fix => a_string_including("bootstrap:nes"))
    end

    it "warns about an older NES release" do
      json = package_json
      json["dependencies"]["bootstrap"] = "npm:#{nes[:package]}@4.6.2-bootstrap-4.6.3"
      write_destination("package.json", JSON.pretty_generate(json))

      expect(check("nes_package")).to include(:status => "warn", :message => a_string_including("4.6.3"))
    end

    it "warns when a token is written into .npmrc" do
      write_destination(".npmrc", "@neverendingsupport:registry=#{nes[:registry]}\n" \
                                  "//registry.nes.herodevs.com/npm/pkg/:_authToken=abc123secret\n")

      expect(check("nes_registry")).to include(:status => "warn", :fix => a_string_including("${HERODEVS_NES_TOKEN}"))
      expect(check("nes_registry").to_s).not_to include("abc123secret")
    end

    it "reports an error without the registry" do
      write_destination(".npmrc", "")

      expect(check("nes_registry")[:status]).to eq("error")
    end

    it "does not treat Bootstrap 4 markup as legacy" do
      write_destination("app/views/tasks/index.html.erb", %{<a data-toggle="modal" class="btn btn-default">x</a>})

      expect(report[:legacy_markup]).to be_empty
      expect(check("legacy_markup")[:message]).to include("Bootstrap 4")
    end

    it "does not look for the vendored Bootstrap 5 files" do
      expect(report[:checks].map { |c| c[:id] }).not_to include("bootstrap_css", "bootstrap_js")
    end
  end

  describe "the agent guide on an NES app" do
    let(:skill) { read_destination(".claude/skills/bootstrap-rails/SKILL.md") }

    before do
      run_generator(described_class)
      Twitter::Bootstrap::Rails.asset_mode = :nes
      run_generator(Bootstrap::Generators::AgentGenerator)
    end

    it "tells agents to write Bootstrap 4 markup and not to use the Bootstrap 5 generators" do
      expect(skill).to include("Bootstrap #{nes[:bootstrap_version]}").and include("HeroDevs")
      expect(skill).to include("Write Bootstrap 4 markup")
      expect(skill).to include("bootstrap-v4-v6-migration")
    end

    it "does not list Bootstrap 4 markup as markup to avoid" do
      expect(skill).not_to include("## Markup to avoid")
    end
  end

  describe "generators that write Bootstrap 5 markup" do
    before { Twitter::Bootstrap::Rails.asset_mode = :nes }

    it "warn on an NES app" do
      expect(run_generator(Bootstrap::Generators::LayoutGenerator)).to include("Bootstrap 5 markup")
      expect(run_generator(Bootstrap::Generators::HeaderGenerator)).to include("Bootstrap 5 markup")
    end
  end
end
