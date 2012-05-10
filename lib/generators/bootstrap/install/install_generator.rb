require 'rails/generators'

module Bootstrap
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Twitter Bootstrap to Asset Pipeline"

      def add_assets

        if File.exist?('app/assets/javascripts/application.js')
          insert_into_file "app/assets/javascripts/application.js", "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
        else
          copy_file "application.js", "app/assets/javascripts/application.js"
        end

        if File.exist?('app/assets/stylesheets/application.css')
          # Add our own require:
          content = File.read("app/assets/stylesheets/application.css")
          if content.match(/require_tree\s+\./)
            # Good enough - that'll include our bootstrap_and_overrides.css.less
          else
            style_require_block = " *= require bootstrap_and_overrides\n"
            insert_into_file "app/assets/stylesheets/application.css", style_require_block, :after => "require_self\n"
          end
        else
          copy_file "application.css", "app/assets/stylesheets/application.css"
        end

      end

      def add_bootstrap
        copy_file "bootstrap.coffee", "app/assets/javascripts/bootstrap.js.coffee"
        copy_file "bootstrap_and_overrides.less", "app/assets/stylesheets/bootstrap_and_overrides.css.less"
      end

      def cleanup_legacy
        # Remove old requires (if any) that included twitter/bootstrap directly:
        gsub_file("app/assets/stylesheets/application.css", %r|\s*\*=\s*twitter/bootstrap\s*\n|, "")
        gsub_file("app/assets/stylesheets/application.css", %r|\s*\*=\s*twitter/bootstrap_responsive\s*\n|, "")
        if File.exist?('app/assets/stylesheets/bootstrap_override.css.less')
          puts <<-EOM
          Warning:
            app/assets/stylesheets/bootstrap_override.css.less exists
            It should be removed, as it has been superceded by app/assets/stylesheets/bootstrap_and_overrides.css.less
          EOM
        end
      end

    end
  end
end
