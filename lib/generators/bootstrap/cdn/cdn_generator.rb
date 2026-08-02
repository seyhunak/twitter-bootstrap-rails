require 'rails/generators'
require 'twitter/bootstrap/rails/version'
require 'generators/bootstrap/cdn_tags'

module Bootstrap
  module Generators
    # Prints the jsDelivr tags for pasting into a layout the user already owns.
    # Writes nothing to disk.
    class CdnGenerator < ::Rails::Generators::Base
      include CdnTags

      desc "Prints the Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION} CDN tags"

      class_option :css, :type => :boolean, :default => false,
                   :desc => 'Print only the stylesheet link'
      class_option :js, :type => :boolean, :default => false,
                   :desc => 'Print only the JavaScript bundle script'
      class_option :'separate-popper', :type => :boolean, :default => false,
                   :desc => 'Print Popper and bootstrap.js as separate tags instead of the bundle'

      def print_tags
        say tags.join("\n")
      end

      private

      def tags
        return [css_tag] if options[:css] && !options[:js]
        return [javascript_tags] if options[:js] && !options[:css]

        [css_tag, javascript_tags]
      end

      def javascript_tags
        options[:'separate-popper'] ? separate_popper_tags : bundle_tag
      end
    end
  end
end
