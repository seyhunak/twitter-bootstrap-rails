module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine
        config.after_initialize do |app|
          # Only run when less is installed
          if app.config.try(:less)
            twitter_bootstrap_less_files = config.root + 'vendor/stylesheets/bootstrap'
            app.config.less.paths << twitter_bootstrap_less_files
          end
        end
      end
    end
  end
end
