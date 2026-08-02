require 'rails/generators'
require 'twitter/bootstrap/rails/version'
require 'twitter/bootstrap/rails/config'
require 'generators/bootstrap/cdn_tags'

module Bootstrap
  module Generators
    class LayoutGenerator < ::Rails::Generators::Base
      include CdnTags

      source_root File.expand_path("../templates", __FILE__)
      desc "This generator generates a Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION} layout file with navigation."
      argument :layout_name, :type => :string, :default => "application"

      class_option :cdn, :type => :boolean, :default => nil,
                   :desc => 'Link Bootstrap from jsDelivr instead of the asset pipeline ' \
                            '(defaults to the mode recorded by bootstrap:install)'
      class_option :'separate-popper', :type => :boolean, :default => false,
                   :desc => 'With --cdn, emit Popper and bootstrap.js as separate tags instead of the bundle'

      attr_reader :app_name

      def warn_about_ignored_options
        return unless options[:'separate-popper'] && !cdn?

        say_status :warn,
          "--separate-popper only applies with --cdn; the vendored asset pipeline ships the bundle. Ignoring.",
          :yellow
      end

      def generate_layout
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        template "layout.html.#{ext}", "app/views/layouts/#{layout_name}.html.#{ext}"
      end

      private

      def cdn?
        return options[:cdn] unless options[:cdn].nil?

        Twitter::Bootstrap::Rails.cdn?
      end

      def separate_popper?
        options[:'separate-popper'] && cdn?
      end

      # The end-of-body CDN script tag(s): one bundle, or the Popper pair.
      def script_tags
        separate_popper? ? separate_popper_tags : bundle_tag
      end

      # Under Sprockets the manifests carry `require` directives, so linking
      # "application" is enough. Propshaft has no directives, so the vendored
      # Bootstrap files have to be named explicitly or they never load.
      def propshaft?
        Twitter::Bootstrap::Rails.propshaft?
      end

      def stylesheet_arguments
        propshaft? ? '"twitter/bootstrap/bootstrap.min", "application"' : '"application"'
      end

      # Propshaft apps (Rails 8) serve their own JavaScript through importmap, so
      # there is no "application.js" asset to link — only Bootstrap's bundle.
      def javascript_arguments
        propshaft? ? '"twitter/bootstrap/bootstrap.bundle.min"' : '"application"'
      end

      # Raw tags indented to sit at the right depth. Haml treats a line starting
      # with a plain character as literal text, so it needs nothing more.
      def indent_tags(tags, indent)
        tags.split("\n").map { |line| "#{indent}#{line}" }.join("\n")
      end

      # Slim needs each raw HTML line introduced by a `|` text marker.
      def slim_tags(tags, indent)
        tags.split("\n").map { |line| "#{indent}| #{line}" }.join("\n")
      end
    end
  end
end
