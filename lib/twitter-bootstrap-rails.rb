module Twitter
  module Bootstrap
      module Rails
        if ::Rails.version < "3.1"
          require "twitter-bootstrap-rails/railtie"
        else
          require "twitter-bootstrap-rails/engine"
        end
      end
   end
end

