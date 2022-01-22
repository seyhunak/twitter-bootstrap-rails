require 'rails'

require_relative 'breadcrumbs.rb'

module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine
        # Helpers are used by framework classes, which are not reloadable. See
        # the initializers below.
        #
        # In consequence, helpers should not be reloadable either. Otherwise,
        # edits would have no effect on the already cached module objects, and
        # that would be confusing.
        config.autoload_once_paths << "#{root}/app/helpers"

        initializer 'twitter-bootstrap-rails.setup',
          :after => 'less-rails.after.load_config_initializers',
          :group => :all do |app|
            if defined?(Less)
              app.config.less.paths << File.join(config.root, 'vendor', 'toolkit')
            end
          end

        initializer 'twitter-bootstrap-rails.setup_helpers' do |app|
          ActiveSupport.on_load(:action_controller_base) do
            include Breadcrumbs

            [FlashBlockHelper,
            BootstrapFlashHelper,
            ModalHelper,
            NavbarHelper,
            BadgeLabelHelper].each do |h|
              helper h
            end
          end

          ActiveSupport.on_load(:action_view) do
            ActionView::Helpers::FormBuilder.send :include, FormErrorsHelper
          end
        end
      end
    end
  end
end
