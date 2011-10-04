module Twitter
  module Bootstrap
    module Rails
      class Engine < ::Rails::Engine

        config.after_initialize do |app|
          twitter_bootstrap_less_files = config.root + 'vendor/stylesheets/bootstrap'
          app.config.less.paths << twitter_bootstrap_less_files

          puts app.config.less.paths.inspect
        end

	    end
    end
  end
end

