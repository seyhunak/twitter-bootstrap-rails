require 'rails'
require File.dirname(__FILE__) + '/twitter-bootstrap-breadcrumbs.rb'

require File.dirname(__FILE__) + '/../../../../app/helpers/flash_block_helper.rb'
require File.dirname(__FILE__) + '/../../../../app/helpers/bread_crumbs_helper.rb'

module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine

        initializer 'twitter-bootstrap-rails.setup_helpers' do |app|
          app.config.to_prepare do
            ActionController::Base.send :helper, BreadCrumbsHelper
            ActionController::Base.send :helper, FlashBlockHelper
          end
        end
      end
    end
  end
end

