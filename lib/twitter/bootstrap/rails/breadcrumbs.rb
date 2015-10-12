module Twitter
  module Bootstrap

    # Keep current method calls as is using aliases
    module Breadcrumbs
      extend ActiveSupport::Concern
      included do
        # Used to provide compatibility with breadcrumbs-on-rails gem, if detected
        # breadcrumbs controller methods won't be overridden.
        if defined?(::BreadcrumbsOnRails)
          ::Rails.logger.info <<-EOT.squish
          BreadcrumbsOnRails detected it won't be overridden. To use methods from this gem you need to call them
          using bootstrap prefix i.e. add_bootstrap_breadcrumb and render_bootstrap_breadcrumbs.
          EOT
        else
          # Provide backward compatibility with existing code
          alias_method :add_breadcrumb, :add_bootstrap_breadcrumb
          class << self
            alias_method :add_breadcrumb, :add_bootstrap_breadcrumb
          end
        end
      end

      module ClassMethods
        def add_bootstrap_breadcrumb(name, url = '', options = {})
          options.merge! :klass => self.name
          before_filter options do |controller|
            controller.send :add_bootstrap_breadcrumb, name, url, options
          end
        end
      end

      protected

      def add_bootstrap_breadcrumb(name, url = '', options = {})
        @__bs_breadcrumbs ||= []

        class_name = options.delete(:klass) || self.class.name

        if name.is_a? Symbol
          if url.blank?
            url_helper = :"#{name}_path"
            url = url_helper if respond_to?(url_helper)
          end

          name = translate_breadcrumb name, class_name
        end

        unless name.is_a? String
          url = polymorphic_path name if url.blank?
          name = name.to_s
        end

        url = eval(url.to_s) if url.is_a?(Symbol) && url =~ /_path|_url|@/

        @__bs_breadcrumbs << {:name => name, :url => url, :options => options}
      end

      def translate_breadcrumb(name, class_name)
        scope = [:breadcrumbs]
        namespace = class_name.underscore.split('/')
        namespace.last.sub!('_controller', '')
        scope += namespace

        I18n.t name, :scope => scope
      end
    end
  end
end
