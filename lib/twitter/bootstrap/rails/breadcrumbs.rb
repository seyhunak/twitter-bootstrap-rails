module Twitter
  module Bootstrap
    module Breadcrumbs
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def add_breadcrumb(name, url = '', options = {})
          options.merge! :klass => self.name
          before_filter options do |controller|
            controller.send :add_breadcrumb, name, url, options
          end
        end
      end

      protected

      def add_breadcrumb(name, url = '', options = {})
        @breadcrumbs ||= []

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

        @breadcrumbs << {:name => name, :url => url, :options => options}
      end

      def translate_breadcrumb(name, class_name)
        scope = [:breadcrumbs]
        namespace = class_name.underscore.split('/')
        namespace.last.sub!('_controller', '')
        scope += namespace

        I18n.t name, :scope => scope
      end

      def render_breadcrumbs(divider = '/')
        s = render :partial => 'twitter-bootstrap/breadcrumbs', :locals => {:divider => divider}
        s.first
      end
    end
  end
end
