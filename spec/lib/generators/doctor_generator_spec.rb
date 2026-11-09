require 'spec_helper'

describe Bootstrap::Generators::DoctorGenerator do
  let(:rails_mod) { Twitter::Bootstrap::Rails }
  let(:version) { rails_mod::BOOTSTRAP_VERSION }

  before { stub_rails_application }

  def report
    rails_mod::Doctor.new(destination_root).report
  end

  def check(id)
    report[:checks].find { |c| c[:id] == id }
  end

  def install_static_on_propshaft
    rails_mod.asset_pipeline = :propshaft
    run_generator(Bootstrap::Generators::InstallGenerator, %w[static])
    run_generator(Bootstrap::Generators::LayoutGenerator)
  end

  describe "where Bootstrap comes from" do
    it "is happy with a Propshaft app set up by the generators" do
      install_static_on_propshaft

      expect(report).to include(:status => "ok", :asset_mode => "static", :asset_pipeline => "propshaft")
    end

    it "is happy with a Sprockets app set up by the generators" do
      rails_mod.asset_pipeline = :sprockets
      run_generator(Bootstrap::Generators::InstallGenerator, %w[static])
      run_generator(Bootstrap::Generators::LayoutGenerator)

      expect(report).to include(:status => "ok", :asset_pipeline => "sprockets")
    end

    it "is happy with a CDN app set up by the generators" do
      run_generator(Bootstrap::Generators::InstallGenerator, %w[cdn])
      run_generator(Bootstrap::Generators::LayoutGenerator, %w[--cdn])

      expect(report).to include(:status => "ok", :asset_mode => "cdn")
    end

    it "reports an error when a Propshaft layout does not link the vendored files" do
      rails_mod.asset_pipeline = :propshaft
      run_generator(Bootstrap::Generators::InstallGenerator, %w[static])
      write_destination("app/views/layouts/application.html.erb", %{<%= stylesheet_link_tag "application" %>})

      expect(check("bootstrap_css")).to include(:status => "error", :fix => a_string_including("bootstrap:layout"))
      expect(check("bootstrap_js")[:status]).to eq("error")
      expect(report[:status]).to eq("error")
    end

    it "reports an error when the layout links vendored files that are not there" do
      rails_mod.asset_pipeline = :propshaft
      write_destination("app/views/layouts/application.html.erb",
                        %{<%= stylesheet_link_tag "twitter/bootstrap/bootstrap.min" %>})

      expect(check("bootstrap_css")).to include(:status => "error", :fix => a_string_including("bootstrap:install"))
    end

    it "reports an error when a Sprockets manifest requires Bootstrap but no layout links it" do
      rails_mod.asset_pipeline = :sprockets
      run_generator(Bootstrap::Generators::InstallGenerator, %w[static])

      expect(check("bootstrap_css")[:status]).to eq("error")
    end

    it "only warns when Bootstrap comes from a JavaScript bundler it can't verify" do
      write_destination("package.json", %{{"dependencies": {"bootstrap": "^5.3.0"}}})

      expect(check("bootstrap_css")[:status]).to eq("warn")
      expect(check("bootstrap_js")[:status]).to eq("warn")
    end

    it "reads the mode from the layout if the initializer is missing" do
      write_destination("app/views/layouts/application.html.erb",
                        %{<link href="https://cdn.jsdelivr.net/npm/bootstrap@#{version}/dist/css/bootstrap.min.css">})

      expect(report[:asset_mode]).to eq("cdn")
      expect(check("bootstrap_css")[:status]).to eq("ok")
      expect(check("bootstrap_js")[:status]).to eq("error")
    end
  end

  describe "the Bootstrap version" do
    it "warns about an old CDN version" do
      write_destination("app/views/layouts/application.html.erb",
                        %{<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css">})

      expect(check("bootstrap_version")).to include(:status => "warn", :message => a_string_including("5.1.0"))
    end

    it "warns about old vendored files" do
      install_static_on_propshaft
      write_destination("app/assets/stylesheets/twitter/bootstrap/bootstrap.min.css", "/*! Bootstrap  v5.3.3 */")

      expect(check("bootstrap_version")).to include(:status => "warn", :message => a_string_including("5.3.3"))
    end

    it "accepts what the generators installed" do
      install_static_on_propshaft

      expect(check("bootstrap_version")[:status]).to eq("ok")
    end
  end

  describe "the icon sprite" do
    let(:layout) { "app/views/layouts/application.html.erb" }

    before { run_generator(Bootstrap::Generators::HeaderGenerator) }

    it "reports an error when it is installed but never rendered" do
      write_destination(layout, "<body></body>")

      expect(check("icon_sprite")).to include(:status => "error", :fix => a_string_including('render "shared/bootstrap_icons"'))
    end

    it "is happy when it is rendered once" do
      write_destination(layout, %{<%= render "shared/bootstrap_icons" %>})

      expect(check("icon_sprite")[:status]).to eq("ok")
    end

    it "warns when it is rendered more than once" do
      write_destination(layout, %{<%= render "shared/bootstrap_icons" %>})
      write_destination("app/views/tasks/index.html.erb", %{<%= render "shared/bootstrap_icons" %>})

      expect(check("icon_sprite")[:status]).to eq("warn")
    end
  end

  it "has nothing to say about the sprite when it is not installed" do
    expect(check("icon_sprite")[:status]).to eq("ok")
  end

  it "warns about placeholder images left in a view, with the location" do
    run_generator(Bootstrap::Generators::HeroGenerator, %w[centered])

    expect(check("placeholder_images")[:status]).to eq("warn")
    expect(check("placeholder_images")[:files].first).to start_with("app/views/shared/_hero.html.erb:")
  end

  describe "legacy markup" do
    it "lists each finding with its location" do
      write_destination("app/views/tasks/index.html.erb", %{<p>ok</p>\n<a class="btn btn-default" data-toggle="modal">x</a>})

      expect(report[:legacy_markup]).to contain_exactly(
        a_hash_including(:file => "app/views/tasks/index.html.erb", :line => 2, :found => "btn-default"),
        a_hash_including(:file => "app/views/tasks/index.html.erb", :line => 2, :found => "data-toggle")
      )
      expect(check("legacy_markup")).to include(:status => "warn", :message => a_string_including("2"))
    end

    it "also scans helpers" do
      write_destination("app/helpers/tasks_helper.rb", %{tag.a("x", class: "pull-right")})

      expect(report[:legacy_markup].first[:found]).to eq("pull-right")
    end

    it "does not scan other directories" do
      write_destination("vendor/theme/index.html.erb", %{<a class="btn-default"></a>})

      expect(report[:legacy_markup]).to be_empty
    end
  end

  describe "Bootstrap 6 migration" do
    def v6_report
      rails_mod::Doctor.new(destination_root).report(:v6 => true)
    end

    it "is left out unless asked for" do
      write_destination("app/views/tasks/index.html.erb", %{<div class="modal-body"></div>})

      expect(report).not_to have_key(:v6_migration)
      expect(report[:checks].map { |c| c[:id] }).not_to include("v6_migration")
    end

    it "lists what changes in Bootstrap 6, with the location" do
      write_destination("app/views/tasks/index.html.erb", %{<p>ok</p>\n<button data-bs-toggle="modal" class="btn btn-primary">x</button>})

      expect(v6_report[:v6_migration]).to contain_exactly(
        a_hash_including(:file => "app/views/tasks/index.html.erb", :line => 2, :found => "btn-primary"),
        a_hash_including(:file => "app/views/tasks/index.html.erb", :line => 2, :found => %{data-bs-toggle="modal"})
      )
      check = v6_report[:checks].find { |c| c[:id] == "v6_migration" }
      expect(check).to include(:status => "warn", :fix => a_string_including("bootstrap-v5-v6-migration"))
    end

    it "scans the app's JavaScript and stylesheets" do
      write_destination("app/javascript/controllers/menu_controller.js", "new bootstrap.Dropdown(this.element)")
      write_destination("app/assets/stylesheets/custom.scss", %{@import "bootstrap/scss/functions";})

      expect(v6_report[:v6_migration].map { |f| f[:file] })
        .to eq(%w[app/assets/stylesheets/custom.scss app/javascript/controllers/menu_controller.js])
    end

    it "skips the Bootstrap files the gem vendored" do
      install_static_on_propshaft
      layout_findings = v6_report[:v6_migration].reject { |f| f[:file].start_with?("app/views/") }

      expect(layout_findings).to be_empty
    end

    it "finds the Bootstrap 5 markup in a layout the generators wrote" do
      install_static_on_propshaft

      expect(v6_report[:v6_migration].map { |f| f[:found] }).to include("navbar-expand-lg")
    end

    it "is happy when nothing needs to change" do
      expect(v6_report[:checks].find { |c| c[:id] == "v6_migration" }[:status]).to eq("ok")
    end
  end

  describe "facts" do
    it "states the versions and template engine" do
      expect(report).to include(
        :bootstrap_version => version,
        :gem_version => rails_mod::VERSION,
        :rails_version => ::Rails.version,
        :template_engine => "erb"
      )
    end
  end

  describe "the command" do
    before { install_static_on_propshaft }

    it "prints the report as JSON with --json" do
      parsed = JSON.parse(run_generator(described_class, %w[--json]))

      expect(parsed).to include("status" => "ok", "bootstrap_version" => version)
      expect(parsed["checks"].map { |c| c["id"] }).to include("bootstrap_css", "legacy_markup")
    end

    it "prints readable lines without --json" do
      output = run_generator(described_class)

      expect(output).to match(/\[ok\]\s+bootstrap_css/)
    end

    it "writes nothing" do
      before = Dir[destination_path("**/*")].sort
      run_generator(described_class)

      expect(Dir[destination_path("**/*")].sort).to eq(before)
    end

    it "exits non-zero when a check fails, so agents and CI can rely on it" do
      FileUtils.rm(destination_path("app/views/layouts/application.html.erb"))

      expect { run_generator(described_class, %w[--json]) }
        .to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
    end

    it "adds the Bootstrap 6 worklist with --v6" do
      parsed = JSON.parse(run_generator(described_class, %w[--v6 --json]))

      expect(parsed["v6_migration"]).to include(a_hash_including("found" => "navbar-expand-lg", "replacement" => "lg:navbar-expand"))
      expect(run_generator(described_class, %w[--v6])).to match(%r{\[warn\]\s+v6_migration.*\n(.*\n)*\s+app/views/layouts/application\.html\.erb:\d+\s+navbar-expand-lg -> lg:navbar-expand})
    end

    it "exits normally on warnings" do
      write_destination("app/views/tasks/index.html.erb", %{<a class="btn-default"></a>})

      expect { run_generator(described_class) }.not_to raise_error
    end
  end
end
