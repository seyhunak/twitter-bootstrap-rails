require 'rails/generators'

module Bootstrap
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)  
      desc "This generator installs Twitter Bootstrap to Asset Pipeline"
                                       
      def add_assets
	      insert_into_file "app/assets/javascripts/application.js", "//= require twitter/bootstrap\n", :after => "jquery_ujs\n"
	      insert_into_file "app/assets/stylesheets/application.css", " *= require twitter/bootstrap\n", :after => "require_self\n"
  	  end
         
      def add_bootstrap
        copy_file "bootstrap.coffee", "app/assets/javascripts/bootstrap.js.coffee"
        copy_file "bootstrap.less", "app/assets/stylesheets/bootstrap.css.less"
      end
      
    end
  end
end
