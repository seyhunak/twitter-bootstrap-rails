require 'rails/generators'

module Bootstrap
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator installs Twitter Bootstrap to Asset Pipeline"

      def add_assets
       if File.exist?('app/assets/javascripts/application.js')
	      insert_into_file "app/assets/javascripts/application.js", "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
	     else
	      copy_file "application.js", "app/assets/javascripts/application.js"
	     end
       if File.exist?('app/assets/stylesheets/application.css')
	      insert_into_file "app/assets/stylesheets/application.css", " *= require twitter/bootstrap\n", :after => "require_self\n"
	     else
	      copy_file "application.css", "app/assets/stylesheets/application.css"
	     end
  	  end

      def add_bootstrap
        copy_file "bootstrap.coffee", "app/assets/javascripts/bootstrap.js.coffee"
        copy_file "bootstrap.less", "app/assets/stylesheets/bootstrap.css.less"
      end

    end
  end
end
