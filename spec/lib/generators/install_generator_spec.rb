require 'spec_helper'

describe Bootstrap::Generators::InstallGenerator do
  let(:vendored_css) { 'app/assets/stylesheets/twitter/bootstrap/bootstrap.min.css' }
  let(:vendored_js) { 'app/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js' }

  describe "static (the default)" do
    it "vendors both Bootstrap dist files into the app" do
      run_generator(described_class, %w[static])

      expect(destination_exist?(vendored_css)).to be true
      expect(destination_exist?(vendored_js)).to be true
    end

    it "vendors the Bootstrap version this gem declares" do
      run_generator(described_class, %w[static])

      expect(read_destination(vendored_css)).to include("Bootstrap  v#{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION}")
      expect(read_destination(vendored_js)).to include("Bootstrap v#{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION}")
    end

    it "defaults to static when no mode is given" do
      run_generator(described_class)

      expect(destination_exist?(vendored_css)).to be true
    end

    it "writes manifests that require the vendored files" do
      run_generator(described_class, %w[static])

      expect(read_destination('app/assets/javascripts/application.js'))
        .to include("//= require twitter/bootstrap/bootstrap.bundle.min")
      expect(read_destination('app/assets/stylesheets/bootstrap_and_overrides.css'))
        .to include("*= require twitter/bootstrap/bootstrap.min")
    end

    it "adds the require lines to manifests the app already has" do
      write_destination('app/assets/javascripts/application.js', "// application\n//= require_tree .\n")
      write_destination('app/assets/stylesheets/application.css', "/*\n *= require_self\n *= require_tree .\n*/\n")

      run_generator(described_class, %w[static])

      expect(read_destination('app/assets/javascripts/application.js'))
        .to include("//= require twitter/bootstrap/bootstrap.bundle.min")
      expect(read_destination('app/assets/stylesheets/application.css'))
        .to include("*= require bootstrap_and_overrides")
    end

    it "says what to add by hand when a manifest has no Sprockets anchor" do
      # A Propshaft app's application.css is plain CSS with nothing to anchor to.
      write_destination('app/assets/stylesheets/application.css', "/*\n * Propshaft manifest.\n */\n")

      output = run_generator(described_class, %w[static])

      expect(output).to match(/has no `require_self` directive to anchor to/)
      expect(output).to include("*= require bootstrap_and_overrides")
      expect(read_destination('app/assets/stylesheets/application.css')).not_to include("require bootstrap_and_overrides")
    end

    it "does not duplicate require lines when run twice" do
      run_generator(described_class, %w[static])
      run_generator(described_class, %w[static])

      js = read_destination('app/assets/javascripts/application.js')
      expect(js.scan("require twitter/bootstrap/bootstrap.bundle.min").length).to eq(1)
    end

    it "writes no CDN initializer" do
      run_generator(described_class, %w[static])

      expect(destination_exist?('config/initializers/bootstrap.rb')).to be false
    end

    it "raises rather than silently installing nothing when a dist file is missing" do
      allow(File).to receive(:file?).and_call_original
      allow(File).to receive(:file?).with(/bootstrap\.min\.css\z/).and_return(false)

      expect {
        run_generator(described_class, %w[static])
      }.to raise_error(described_class::MissingAssetError, /bootstrap\.min\.css/)
    end
  end

  # Propshaft is the Rails 8 default and has no Sprockets directives: a
  # `//= require` line there is an inert comment, so writing manifests that rely
  # on one would ship an app with no Bootstrap at all.
  describe "static on a Propshaft app" do
    before { Twitter::Bootstrap::Rails.asset_pipeline = :propshaft }

    it "still vendors both dist files" do
      run_generator(described_class, %w[static])

      expect(destination_exist?(vendored_css)).to be true
      expect(destination_exist?(vendored_js)).to be true
    end

    it "writes no Sprockets manifests" do
      run_generator(described_class, %w[static])

      expect(destination_exist?('app/assets/javascripts/application.js')).to be false
      expect(destination_exist?('app/assets/stylesheets/bootstrap_and_overrides.css')).to be false
    end

    it "does not touch an existing application.css" do
      original = "/*\n * Propshaft manifest.\n */\n"
      write_destination('app/assets/stylesheets/application.css', original)

      run_generator(described_class, %w[static])

      expect(read_destination('app/assets/stylesheets/application.css')).to eq(original)
    end

    it "points the user at bootstrap:layout" do
      output = run_generator(described_class, %w[static])

      expect(output).to match(/vendored for Propshaft/)
    end
  end

  describe "cdn" do
    it "vendors nothing" do
      run_generator(described_class, %w[cdn])

      expect(destination_exist?(vendored_css)).to be false
      expect(destination_exist?(vendored_js)).to be false
    end

    it "writes an initializer selecting cdn mode" do
      run_generator(described_class, %w[cdn])

      expect(read_destination('config/initializers/bootstrap.rb'))
        .to include("Twitter::Bootstrap::Rails.asset_mode = :cdn")
    end

    it "creates no asset manifests" do
      run_generator(described_class, %w[cdn])

      expect(destination_exist?('app/assets/javascripts/application.js')).to be false
      expect(destination_exist?('app/assets/stylesheets/bootstrap_and_overrides.css')).to be false
    end
  end

  it "rejects an unknown mode" do
    expect {
      run_generator(described_class, %w[less])
    }.to raise_error(Rails::Generators::Error, /Expected 'static' or 'cdn'/)
  end
end
