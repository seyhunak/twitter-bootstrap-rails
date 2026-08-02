require 'rails/generators'
require 'twitter/bootstrap/rails/version'
require 'generators/bootstrap/snippets/snippet_catalog'

module Bootstrap
  module Generators
    # Shared behaviour for the per-category snippet generators (bootstrap:header,
    # bootstrap:hero, ...). Each subclass only declares which docs category it
    # serves; everything else lives here.
    class SnippetBase < ::Rails::Generators::Base
      ICONS_PARTIAL = 'bootstrap_icons'.freeze

      argument :requested_variant, :type => :string, :required => false,
               :default => nil, :banner => 'VARIANT'

      class_option :as, :type => :string,
                   :desc => 'Partial name to write (defaults to the generator name)'
      class_option :path, :type => :string, :default => 'app/views/shared',
                   :desc => 'Directory to write the partial into'
      class_option :list, :type => :boolean, :default => false,
                   :desc => 'List the available variants and exit'
      class_option :icons, :type => :boolean, :default => true,
                   :desc => 'Also install the shared Bootstrap Icons sprite when the snippet needs it'

      # Subclasses call `snippet_category "headers"`.
      def self.snippet_category(category = nil)
        @snippet_category = category if category
        @snippet_category
      end

      def self.source_root
        File.expand_path("../templates", __FILE__)
      end

      def self.banner
        "rails generate #{namespace} [VARIANT] [options]"
      end

      def list_variants
        return unless options[:list]

        say "#{category} variants:\n\n"
        SnippetCatalog.variants(category).each do |v|
          say format("  %-22s %s%s", v[:name], v[:description], v[:icons] ? " (uses icons)" : "")
        end
        say "\nDefault: #{SnippetCatalog.default_variant(category)}"
      end

      def copy_snippet
        return if options[:list]

        copy_file "#{category}/#{variant_name}.html.erb", partial_path
      end

      def copy_icons
        return if options[:list]
        return unless variant[:icons] && options[:icons]

        copy_file "icons/_#{ICONS_PARTIAL}.html.erb",
                  File.join(options[:path], "_#{ICONS_PARTIAL}.html.erb")
      end

      def report
        return if options[:list]

        say "\nRender it with:  <%= render \"#{render_path}\" %>"
        if variant[:icons] && options[:icons]
          say "The snippet uses Bootstrap Icons; render the sprite once in your layout:"
          say "                 <%= render \"#{icons_render_path}\" %>"
        end
      end

      private

      def category
        self.class.snippet_category
      end

      # The variant argument, or the category's first variant.
      def variant_name
        name = (requested_variant || SnippetCatalog.default_variant(category)).to_s.tr('-', '_')

        unless SnippetCatalog.variant(category, name)
          raise ::Rails::Generators::Error,
            "Unknown #{category} variant #{name.inspect}. Available: " \
            "#{SnippetCatalog.variant_names(category).join(', ')}. " \
            "Run `rails g #{self.class.namespace} --list` for descriptions."
        end

        name
      end

      def variant
        SnippetCatalog.variant(category, variant_name)
      end

      def partial_name
        options[:as] || self.class.generator_name
      end

      def partial_path
        File.join(options[:path], "_#{partial_name}.html.erb")
      end

      # "app/views/shared/_header.html.erb" -> "shared/header"
      def render_path
        strip_view_path(partial_name)
      end

      def icons_render_path
        strip_view_path(ICONS_PARTIAL)
      end

      def strip_view_path(name)
        dir = options[:path].sub(%r{\Aapp/views/}, '')
        dir.empty? ? name : File.join(dir, name)
      end
    end
  end
end
