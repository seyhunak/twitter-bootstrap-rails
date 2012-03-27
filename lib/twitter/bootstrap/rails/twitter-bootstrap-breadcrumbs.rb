module Twitter
  module Bootstrap
    module BreadCrumbs
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def add_breadcrumb name, url, options={}
          before_filter options do |controller|
            controller.send :add_breadcrumb, name, url
          end
        end
      end

      protected

      def add_breadcrumb name, url = ''
        @breadcrumbs ||= []
        url = eval(url) if url =~ /_path|_url|@/
          @breadcrumbs << {:name => name, :url => url}
      end

      def render_breadcrumbs(divider = '/')
        s = render :partial => 'twitter-bootstrap/breadcrumbs', :locals => {:divider => divider}
        s.html_safe
      end
    end
  end
end
