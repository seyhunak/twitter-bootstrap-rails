require "twitter/bootstrap/rails/version"

module Twitter
  module Bootstrap
    module Rails
      # How the host app loads Bootstrap's assets. `rails g bootstrap:install cdn`
      # writes an initializer setting this to :cdn; `bootstrap:layout` reads it to
      # pick its default. Defaults to :static so the layout generator works whether
      # or not that initializer exists.
      VALID_ASSET_MODES = [:static, :cdn].freeze

      @asset_mode = :static

      class << self
        attr_reader :asset_mode

        def asset_mode=(mode)
          mode = mode.to_sym
          unless VALID_ASSET_MODES.include?(mode)
            raise ArgumentError,
              "asset_mode must be one of #{VALID_ASSET_MODES.inspect}, got #{mode.inspect}"
          end
          @asset_mode = mode
        end

        def cdn?
          asset_mode == :cdn
        end

        # Which asset pipeline the host app runs. Propshaft (the Rails 8 default)
        # has no Sprockets directives: a `//= require` line in a manifest is an
        # inert comment there, so assets have to be linked explicitly instead.
        def asset_pipeline
          return @asset_pipeline if defined?(@asset_pipeline) && @asset_pipeline

          if defined?(::Propshaft)
            :propshaft
          elsif defined?(::Sprockets)
            :sprockets
          else
            :unknown
          end
        end

        # Set explicitly to override detection (used by the specs).
        attr_writer :asset_pipeline

        def propshaft?
          asset_pipeline == :propshaft
        end
      end
    end
  end
end
