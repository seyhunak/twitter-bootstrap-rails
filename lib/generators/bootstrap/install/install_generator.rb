require 'rails/generators'

module Bootstrap
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Bootstrap to Asset Pipeline"
      argument :stylesheets_type, :type => :string, :default => 'less', :banner => '*less or static'
      class_option :'no-coffeescript', :type => :boolean, :default => false, :desc => 'Skips coffeescript replacement into app generators'

      def add_assets

        js_manifest = 'app/assets/javascripts/application.js'

        if File.exist?(js_manifest)
          insert_into_file js_manifest, "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
        else
          copy_file "application.js", js_manifest
        end

        css_manifest = 'app/assets/stylesheets/application.css'

        if File.exist?(css_manifest)
          # Add our own require:
          content = File.read(css_manifest)
          if content.match(/require_tree\s+\.\s*$/)
            # Good enough - that'll include our bootstrap_and_overrides.css.less
          else
            style_require_block = " *= require bootstrap_and_overrides\n"
            insert_into_file css_manifest, style_require_block, :after => "require_self\n"
          end
        else
          copy_file "application.css", "app/assets/stylesheets/application.css"
        end

      end

      def add_bootstrap
        if use_coffeescript?
          copy_file "bootstrap.coffee", "app/assets/javascripts/bootstrap.js.coffee"
        else
          copy_file "bootstrap.js", "app/assets/javascripts/bootstrap.js"
        end
        if use_less?
          copy_file "bootstrap_and_overrides.less", "app/assets/stylesheets/bootstrap_and_overrides.css.less"
        else
          copy_file "bootstrap_and_overrides.css", "app/assets/stylesheets/bootstrap_and_overrides.css"
        end
      end

      def add_locale
        if File.exist?("config/locales/en.bootstrap.yml")
          localez = File.read("config/locales/en.bootstrap.yml")
          insert_into_file "config/locales/en.bootstrap.yml", localez, :after => "en\n"
        else
          copy_file "en.bootstrap.yml", "config/locales/en.bootstrap.yml"
        end
      end

      def cleanup_legacy
        # Remove old requires (if any) that included twitter/bootstrap directly:
        gsub_file("app/assets/stylesheets/application.css", %r|\s*\*=\s*twitter/bootstrap\s*\n|, "")
        if File.exist?('app/assets/stylesheets/bootstrap_override.css.less')
          puts <<-EOM
          Warning:
            app/assets/stylesheets/bootstrap_override.css.less exists
            It should be removed, as it has been superceded by app/assets/stylesheets/bootstrap_and_overrides.css.less
          EOM
        end
      end

    private
      def use_less?
        (defined?(Less) && (stylesheets_type!='static') ) || (stylesheets_type=='less')
      end

      def use_coffeescript?
        return false if options[:'no-coffeescript']
        ::Rails.configuration.app_generators.rails[:javascript_engine] == :coffee
      end
    end
  end
end
