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
      MODES = %w[static cdn importmap].freeze

      argument :asset_mode, :type => :string, :default => 'static',
               :banner => MODES.join(' | '),
               :desc => 'static vendors Bootstrap into the asset pipeline; cdn links to jsDelivr; ' \
                        'importmap vendors the stylesheet and pins Bootstrap as an ES module'

      STYLESHEET = ['vendor/assets/stylesheets/twitter/bootstrap/bootstrap.min.css',
                    'app/assets/stylesheets/twitter/bootstrap/bootstrap.min.css'].freeze
      BUNDLE = ['vendor/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js',
                'app/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js'].freeze
      # importmap-rails serves vendor/javascript, and these paths are what the pins name.
      ES_MODULES = [
        ['vendor/assets/javascripts/twitter/bootstrap/bootstrap.esm.min.js',
         'vendor/javascript/twitter/bootstrap/bootstrap.esm.min.js'],
        ['vendor/assets/javascripts/twitter/bootstrap/popper.esm.js',
         'vendor/javascript/twitter/bootstrap/popper.esm.js']
      ].freeze
      PINS = {
        "bootstrap" => ["twitter/bootstrap/bootstrap.esm.min.js", "Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION}"],
        "@popperjs/core" => ["twitter/bootstrap/popper.esm.js", "Popper #{Twitter::Bootstrap::Rails::POPPER_VERSION}"]
      }.freeze
      IMPORTMAP = "config/importmap.rb".freeze
      APPLICATION_JS = "app/javascript/application.js".freeze

      def validate_asset_mode
        unless MODES.include?(asset_mode)
          raise ::Rails::Generators::Error,
            "Unknown asset mode #{asset_mode.inspect}. Expected one of #{MODES.join(', ')}. " \
            "For HeroDevs Bootstrap NES 4.6, run `rails g bootstrap:nes`."
        end

        return unless importmap? && !exists_in_app?(IMPORTMAP)

        raise ::Rails::Generators::Error,
          "importmap mode needs importmap-rails, but #{IMPORTMAP} does not exist. " \
          "Run `bin/rails importmap:install` first, or use `bootstrap:install static`."
      end

      def add_assets
        return if cdn?
        # Propshaft has no require directives to add; bootstrap:layout links the
        # vendored files explicitly instead.
        return if propshaft?

        js_manifest = 'app/assets/javascripts/application.js'

        if importmap?
          # Bootstrap's JavaScript comes from the importmap, not the manifest.
        elsif exists_in_app?(js_manifest)
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

        vendored = [STYLESHEET] + (importmap? ? ES_MODULES : [BUNDLE])
        vendored.each do |relative_source, destination|
          source = File.join(gem_root, relative_source)

          unless File.file?(source)
            raise MissingAssetError,
              "Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION} asset missing from the gem: " \
              "#{relative_source}. The gem install looks incomplete; reinstall twitter-bootstrap-rails."
          end

          create_file destination, File.binread(source)
        end
      end

      def pin_modules
        return unless importmap?

        existing = read_from_app(IMPORTMAP)
        pins = PINS.reject { |name, _| existing.match?(/^\s*pin\s+["']#{Regexp.escape(name)}["']/) }
                   .map { |name, (path, label)| %{pin "#{name}", to: "#{path}" # #{label} via twitter-bootstrap-rails\n} }
        append_to_file IMPORTMAP, "\n" + pins.join unless pins.empty?

        if exists_in_app?(APPLICATION_JS)
          unless read_from_app(APPLICATION_JS).match?(/^\s*import\s+(?:\*\s+as\s+\w+\s+from\s+)?["']bootstrap["']/)
            append_to_file APPLICATION_JS, %{import "bootstrap"\n}
          end
        else
          say_status :warn, "#{APPLICATION_JS} not found. Add `import \"bootstrap\"` to your JavaScript entry point.", :yellow
        end
      end

      def add_bootstrap
        return if cdn?
        return if propshaft?

        copy_file "bootstrap.js", "app/assets/javascripts/bootstrap.js" unless importmap?
        copy_file "bootstrap_and_overrides.css", "app/assets/stylesheets/bootstrap_and_overrides.css"
      end

      def add_mode_initializer
        if cdn?
          create_file "config/initializers/bootstrap.rb", <<~RUBY
            # Bootstrap's CSS and JS are loaded from jsDelivr rather than vendored into
            # this app. `rails g bootstrap:layout` reads this to emit CDN tags by default.
            Twitter::Bootstrap::Rails.asset_mode = :cdn
          RUBY
        elsif importmap?
          create_file "config/initializers/bootstrap.rb", <<~RUBY
            # Bootstrap's stylesheet is vendored into the asset pipeline and its JavaScript
            # is pinned in config/importmap.rb. `rails g bootstrap:layout` reads this to
            # leave Bootstrap's JavaScript to the importmap.
            Twitter::Bootstrap::Rails.asset_mode = :importmap
          RUBY
        end
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
        elsif importmap?
          say "Bootstrap #{version} pinned in #{IMPORTMAP} and imported from #{APPLICATION_JS}. " \
              "Use `import { Tooltip } from \"bootstrap\"` in your own modules. " \
              "Run `rails g bootstrap:layout` if your layout doesn't link the stylesheet yet."
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

      def importmap?
        asset_mode == 'importmap'
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
