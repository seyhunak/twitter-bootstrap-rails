require 'spec_helper'

describe Bootstrap::Generators::LayoutGenerator do
  let(:cdn) { Twitter::Bootstrap::Rails::BOOTSTRAP_CDN }

  # The generated layout for the given engine.
  def generate_layout(args = [], engine: :erb)
    stub_rails_application(engine)
    run_generator(described_class, args)
    read_destination("app/views/layouts/application.html.#{engine}")
  end

  [:erb, :haml, :slim].each do |engine|
    context "with the #{engine} template engine" do
      it "uses the asset pipeline by default" do
        layout = generate_layout([], :engine => engine)

        expect(layout).to include('stylesheet_link_tag "application"')
        expect(layout).to include('javascript_include_tag "application"')
        expect(layout).not_to include("cdn.jsdelivr.net")
      end

      it "emits the CDN link and bundle with --cdn" do
        layout = generate_layout(%w[--cdn], :engine => engine)

        expect(layout).to include(cdn[:css][:url])
        expect(layout).to include(cdn[:css][:integrity])
        expect(layout).to include(cdn[:bundle][:url])
        expect(layout).to include(cdn[:bundle][:integrity])
        expect(layout).to include('crossorigin="anonymous"')
      end

      it "does not also link the pipeline when using --cdn" do
        layout = generate_layout(%w[--cdn], :engine => engine)

        expect(layout).not_to include('stylesheet_link_tag')
        expect(layout).not_to include('javascript_include_tag')
      end

      it "emits Popper and bootstrap.js instead of the bundle with --cdn --separate-popper" do
        layout = generate_layout(%w[--cdn --separate-popper], :engine => engine)

        expect(layout).to include(cdn[:popper][:url])
        expect(layout).to include(cdn[:popper][:integrity])
        expect(layout).to include(cdn[:js][:url])
        expect(layout).to include(cdn[:js][:integrity])
        expect(layout).not_to include(cdn[:bundle][:url])
      end

      it "includes the important globals: doctype, html lang, and viewport" do
        layout = generate_layout([], :engine => engine)

        expect(layout).to match(/\A(<!doctype html>|!!!|doctype html)/)
        expect(layout).to match(/lang[^\n]*en/)
        expect(layout).to include("width=device-width, initial-scale=1")
      end

      it "carries no Bootstrap 3 markup" do
        layout = generate_layout([], :engine => engine)

        expect(layout).not_to include("navbar-default")
        expect(layout).not_to include("icon-bar")
        expect(layout).not_to include("html5shiv")
        expect(layout).not_to match(/\bwell\b/)
      end
    end
  end

  describe "on a Propshaft app" do
    before { Twitter::Bootstrap::Rails.asset_pipeline = :propshaft }

    [:erb, :haml, :slim].each do |engine|
      it "links the vendored Bootstrap explicitly in #{engine}, since require directives are inert" do
        layout = generate_layout([], :engine => engine)

        expect(layout).to include('stylesheet_link_tag "twitter/bootstrap/bootstrap.min", "application"')
        expect(layout).to include('javascript_include_tag "twitter/bootstrap/bootstrap.bundle.min"')
      end
    end

    it "does not link an application.js that Propshaft apps do not have" do
      layout = generate_layout

      expect(layout).not_to include('javascript_include_tag "twitter/bootstrap/bootstrap.bundle.min", "application"')
    end

    it "still uses the CDN when asked" do
      layout = generate_layout(%w[--cdn])

      expect(layout).to include(cdn[:css][:url])
      expect(layout).not_to include('stylesheet_link_tag')
    end
  end

  it "names the layout after the given argument" do
    stub_rails_application(:erb)
    run_generator(described_class, %w[admin])

    expect(destination_exist?("app/views/layouts/admin.html.erb")).to be true
  end

  it "warns and falls back to the bundle when --separate-popper is used without --cdn" do
    stub_rails_application(:erb)
    output = run_generator(described_class, %w[--separate-popper])

    expect(output).to match(/separate-popper only applies with --cdn/)
    expect(read_destination("app/views/layouts/application.html.erb")).not_to include(cdn[:popper][:url])
  end

  it "defaults to CDN tags when bootstrap:install recorded cdn mode" do
    Twitter::Bootstrap::Rails.asset_mode = :cdn
    layout = generate_layout

    expect(layout).to include(cdn[:css][:url])
  end

  it "lets --no-cdn override a recorded cdn mode" do
    Twitter::Bootstrap::Rails.asset_mode = :cdn
    layout = generate_layout(%w[--no-cdn])

    expect(layout).to include('stylesheet_link_tag "application"')
    expect(layout).not_to include("cdn.jsdelivr.net")
  end
end
