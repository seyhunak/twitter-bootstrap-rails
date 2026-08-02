require 'rails/generators'
require 'fileutils'
require 'twitter/bootstrap/rails/version'

module Bootstrap
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      # Raised when a dist file that should ship with the gem is missing, rather
      # than silently installing nothing.
      class MissingAssetError < StandardError; end

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION} to the Asset Pipeline"
      argument :asset_mode, :type => :string, :default => 'static',
               :banner => 'static or cdn',
               :desc => 'static vendors Bootstrap into the app; cdn links to jsDelivr instead'

      VENDORED_ASSETS = [
        ['vendor/assets/stylesheets/twitter/bootstrap/bootstrap.min.css',
         'app/assets/stylesheets/twitter/bootstrap/bootstrap.min.css'],
        ['vendor/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js',
         'app/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js']
      ].freeze

      def validate_asset_mode
        return if %w[static cdn].include?(asset_mode)

        raise ::Rails::Generators::Error,
          "Unknown asset mode #{asset_mode.inspect}. Expected 'static' or 'cdn'."
      end

      def add_assets
        return if cdn?
        # Propshaft has no require directives to add; bootstrap:layout links the
        # vendored files explicitly instead.
        return if propshaft?

        js_manifest = 'app/assets/javascripts/application.js'

        if exists_in_app?(js_manifest)
          add_require(js_manifest,
                      "//= require twitter/bootstrap/bootstrap.bundle.min\n",
                      "application\n",
                      'twitter/bootstrap')
        else
          copy_file "application.js", js_manifest
        end

        css_manifest = 'app/assets/stylesheets/application.css'

        if exists_in_app?(css_manifest)
          add_require(css_manifest,
                      " *= require bootstrap_and_overrides\n",
                      "require_self\n",
                      'bootstrap')
        else
          copy_file "application.css", css_manifest
        end
      end

      def copy_bootstrap_assets
        return if cdn?

        VENDORED_ASSETS.each do |relative_source, destination|
          source = File.join(gem_root, relative_source)

          unless File.file?(source)
            raise MissingAssetError,
              "Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION} asset missing from the gem: " \
              "#{relative_source}. The gem install looks incomplete; reinstall twitter-bootstrap-rails."
          end

          create_file destination, File.binread(source)
        end
      end

      def add_bootstrap
        return if cdn?
        return if propshaft?

        copy_file "bootstrap.js", "app/assets/javascripts/bootstrap.js"
        copy_file "bootstrap_and_overrides.css", "app/assets/stylesheets/bootstrap_and_overrides.css"
      end

      def add_cdn_initializer
        return unless cdn?

        create_file "config/initializers/bootstrap.rb", <<~RUBY
          # Bootstrap's CSS and JS are loaded from jsDelivr rather than vendored into
          # this app. `rails g bootstrap:layout` reads this to emit CDN tags by default.
          Twitter::Bootstrap::Rails.asset_mode = :cdn
        RUBY
      end

      def add_locale
        return if exists_in_app?("config/locales/en.bootstrap.yml")

        copy_file "en.bootstrap.yml", "config/locales/en.bootstrap.yml"
      end

      def cleanup_legacy
        return unless exists_in_app?('app/assets/stylesheets/application.css')

        gsub_file("app/assets/stylesheets/application.css", %r|\s*\*=\s*twitter/bootstrap\s*\n|, "", :verbose => false)
      end

      def report
        version = Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION

        if cdn?
          say "Bootstrap #{version} will be loaded from jsDelivr. " \
              "Run `rails g bootstrap:layout` to generate a layout with the CDN tags."
        elsif propshaft?
          say "Bootstrap #{version} vendored for Propshaft. " \
              "Run `rails g bootstrap:layout` to generate a layout that links it."
        else
          say "Bootstrap #{version} vendored into the asset pipeline."
        end
      end

      private

      def cdn?
        asset_mode == 'cdn'
      end

      def propshaft?
        Twitter::Bootstrap::Rails.propshaft?
      end

      def gem_root
        File.expand_path("../../../../..", __FILE__)
      end

      # Adds a Sprockets require to an existing manifest. Apps on Propshaft (the
      # Rails 8 default) have no Sprockets directives to anchor to, so rather than
      # letting the insert quietly fail, say what to add by hand.
      def add_require(manifest, directive, anchor, marker)
        content = read_from_app(manifest)
        return if content.include?(marker)

        if content.include?(anchor)
          insert_into_file manifest, directive, :after => anchor
        else
          say_status :warn,
            "#{manifest} has no `#{anchor.strip}` directive to anchor to — it is probably not a " \
            "Sprockets manifest. Add this line yourself: #{directive.strip}",
            :yellow
        end
      end

      # Paths in a generator are relative to the destination root, not the
      # working directory, so they have to be resolved before touching the disk.
      def exists_in_app?(relative)
        File.exist?(File.join(destination_root, relative))
      end

      def read_from_app(relative)
        File.read(File.join(destination_root, relative))
      end
    end
  end
end
