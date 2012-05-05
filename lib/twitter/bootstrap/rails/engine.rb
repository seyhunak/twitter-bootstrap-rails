require 'rails'
require File.dirname(__FILE__) + '/twitter-bootstrap-breadcrumbs.rb'

module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine

        initializer 'twitter-bootstrap-rails.setup', 
          :after => 'less-rails.after.load_config_initializers', 
          :group => :all do |app|
          app.config.less.paths << File.join(config.root, 'vendor', 'toolkit')
          end

        initializer 'twitter-bootstrap-rails.setup_helpers' do |app|
          app.config.to_prepare do
            ActionController::Base.send :include, BreadCrumbs
            #ActionController::Base.send :helper_method, :render_breadcrumbs
          end
        end
      end
    end
  end
end
