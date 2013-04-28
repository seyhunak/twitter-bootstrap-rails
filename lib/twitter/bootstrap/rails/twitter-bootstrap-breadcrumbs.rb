module Twitter
  module Bootstrap
    module BreadCrumbs
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def add_breadcrumb(name, url, options = {})
          class_name = self.name
          before_filter options do |controller|
            name = controller.send :translate_breadcrumb, name, class_name if name.is_a?(Symbol)
            controller.send :add_breadcrumb, name, url
          end
        end
      end

      protected

      def add_breadcrumb(name, url = '', options = {})
        @breadcrumbs ||= []
        name = translate_breadcrumb(name, self.class.name) if name.is_a?(Symbol)
        url = eval(url.to_s) if url =~ /_path|_url|@/
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
