require 'rails'

module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine
     
        initializer 'twitter-bootstrap-rails.setup', 
          :after => 'less-rails.after.load_config_initializers', 
          :group => :all do |app|
            app.config.less.paths << File.join(config.root, 'vendor', 'toolkit')
        end

      end
    end
  end
end
