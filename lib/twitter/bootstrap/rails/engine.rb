require 'rails'
require 'json'

require_relative '../../../../app/helpers/breadcrumbs.rb'
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
          :group => :all do |app|
              bowerrc = File.read(File.join(config.root, '.bowerrc'))
              bowerrc_directory = JSON.parse(bowerrc)
              app.config.assets.paths << File.join(bowerrc["directory"])
            end

        initializer 'twitter-bootstrap-rails.setup_helpers' do |app|
          app.config.to_prepare do
            ActionController::Base.send :include, Twitter::Bootstrap::Breadcrumbs
          end

          [FlashBlockHelper, 
          BootstrapFlashHelper, 
          FormErrorsHelper, 
          ModalHelper,
          GlyphHelper,
          IconHelper,
          NavbarHelper,
          BadgeLabelHelper].each do |h|
            app.config.to_prepare do
              ActionController::Base.send :helper, h
            end
          end
        end
      end
    end
  end
end