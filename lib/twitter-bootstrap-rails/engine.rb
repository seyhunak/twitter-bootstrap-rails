module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine
        config.after_initialize do |app|
          # Only run when less is installed
          if app.config.try(:less)
            app.config.less.paths << "#{config.root}vendor/stylesheets/bootstrap"
            app.config.less.paths << "#{config.root}vendor/assets/stylesheets/bootstrap"
          end
        end
      end
    end
  end
end
