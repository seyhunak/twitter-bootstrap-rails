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
      class_option :bootstrap, :type => :string, :default => "5",
                   :desc => "Bootstrap major version: 5 (#{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION}) or 6 " \
                            "(the #{Twitter::Bootstrap::Rails::BOOTSTRAP_NEXT_VERSION} prerelease)"

      def validate_version
        unless %w[5 6].include?(options[:bootstrap])
          raise ::Rails::Generators::Error,
            "--bootstrap must be 5 or 6. For HeroDevs Bootstrap NES 4.6, run `rails g bootstrap:nes`."
        end
        return unless next_version? && options[:'separate-popper']

        raise ::Rails::Generators::Error,
          "--separate-popper does not apply to Bootstrap 6, whose bundle includes Floating UI."
      end

      def print_tags
        say tags.join("\n")
      end

      def warn_about_prerelease
        return unless next_version?

        say_status :warn,
          "Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_NEXT_VERSION} is a prerelease. This gem's generators and helpers " \
          "write Bootstrap 5 markup, which needs migrating: run `rails g bootstrap:doctor --v6` for the list.",
          :yellow
      end

      private

      def next_version?
        options[:bootstrap] == "6"
      end

      def tags
        css = next_version? ? next_css_tag : css_tag
        return [css] if options[:css] && !options[:js]
        return [javascript_tags] if options[:js] && !options[:css]

        [css, javascript_tags]
      end

      def javascript_tags
        return next_bundle_tag if next_version?

        options[:'separate-popper'] ? separate_popper_tags : bundle_tag
      end
    end
  end
end
