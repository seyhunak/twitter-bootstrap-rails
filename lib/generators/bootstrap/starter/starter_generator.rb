require 'rails/generators'
require 'twitter/bootstrap/rails/version'
require 'generators/bootstrap/cdn_tags'

module Bootstrap
  module Generators
    # Writes the starter template from
    # https://getbootstrap.com/docs/5.3/getting-started/introduction/
    class StarterGenerator < ::Rails::Generators::Base
      include CdnTags

      source_root File.expand_path("../templates", __FILE__)
      desc "Writes the Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION} starter HTML template"

      class_option :path, :type => :string, :default => 'public/bootstrap-starter.html',
                   :desc => 'Where to write the starter template'
      class_option :'separate-popper', :type => :boolean, :default => false,
                   :desc => 'Emit Popper and bootstrap.js as separate tags instead of the bundle'

      def create_starter_template
        template "starter.html.erb", options[:path]
      end

      def report
        say "Open #{options[:path]} in a browser to check your Bootstrap setup."
      end

      private

      # The docs' starter uses the single bundle; --separate-popper swaps in the pair.
      def script_tags
        tags = options[:'separate-popper'] ? separate_popper_tags : bundle_tag
        tags.split("\n").join("\n    ")
      end
    end
  end
end
