require 'rails'

require_relative 'breadcrumbs.rb'
require_relative '../../../../app/helpers/flash_block_helper.rb'
require_relative '../../../../app/helpers/modal_helper.rb'
require_relative '../../../../app/helpers/navbar_helper.rb'
require_relative '../../../../app/helpers/bootstrap_flash_helper.rb'
require_relative '../../../../app/helpers/form_errors_helper.rb'

module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine
        initializer 'twitter-bootstrap-rails.setup',
          :after => 'less-rails.after.load_config_initializers',
          :group => :all do |app|
            if defined?(Less)
              app.config.less.paths << File.join(config.root, 'vendor', 'toolkit')
            end
          end

        initializer 'twitter-bootstrap-rails.setup_helpers' do |app|
          app.config.to_prepare do
            ActionController::Base.send :include, Breadcrumbs
          end
          [FlashBlockHelper,
          BootstrapFlashHelper,
          ModalHelper,
          NavbarHelper,
          BadgeLabelHelper].each do |h|
            app.config.to_prepare do
              ActionController::Base.send :helper, h
            end
          end
          ActionView::Helpers::FormBuilder.send :include, FormErrorsHelper
        end
      end
    end
  end
end
