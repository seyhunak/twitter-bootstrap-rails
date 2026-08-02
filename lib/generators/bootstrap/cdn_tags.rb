require "twitter/bootstrap/rails/version"

module Bootstrap
  module Generators
    # Renders the jsDelivr tags from the Introduction page, built from the
    # constants in Twitter::Bootstrap::Rails so no template hardcodes a version
    # or an integrity hash.
    module CdnTags
      def css_tag
        entry = cdn(:css)
        %{<link href="#{entry[:url]}" rel="stylesheet" integrity="#{entry[:integrity]}" crossorigin="anonymous">}
      end

      def bundle_tag
        script_tag(:bundle)
      end

      def js_tag
        script_tag(:js)
      end

      def popper_tag
        script_tag(:popper)
      end

      # Popper and bootstrap.js as the separate pair, in the docs' order.
      def separate_popper_tags
        [popper_tag, js_tag].join("\n")
      end

      private

      def script_tag(key)
        entry = cdn(key)
        %{<script src="#{entry[:url]}" integrity="#{entry[:integrity]}" crossorigin="anonymous"></script>}
      end

      def cdn(key)
        Twitter::Bootstrap::Rails::BOOTSTRAP_CDN.fetch(key)
      end
    end
  end
end
