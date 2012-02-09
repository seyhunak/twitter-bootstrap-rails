require 'rails/generators'

module Bootstrap
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Twitter Bootstrap to Asset Pipeline"

      def add_assets
        path_main_js_file = 'app/assets/javascripts/application.js'
        path_main_coffee_file = 'app/assets/javascripts/application.js.coffee'

        if File.exist?(path_main_js_file)
          if File.open(path_main_js_file).lines.any?{|line| line.exclude?('twitter/bootstrap')}
            insert_into_file path_main_js_file, "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
          end
        else
          if File.exist?(path_main_coffee_file)
            if File.open(path_main_coffee_file).lines.any?{|line| line.exclude?('twitter/bootstrap')}
              insert_into_file path_main_coffee_file, "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
            end
          else
            copy_file "application.js", path_main_js_file
          end
        end
  	  end

      def add_bootstrap
        copy_file "bootstrap.coffee", "app/assets/javascripts/bootstrap/bootstrap.js.coffee"
        copy_file "bootstrap.less", "app/assets/stylesheets/bootstrap/bootstrap.css.less"
      end

    end
  end
end
