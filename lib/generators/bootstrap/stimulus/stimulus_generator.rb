require 'rails/generators'

module Bootstrap
  module Generators
    # Writes a Stimulus controller that sets up Bootstrap's tooltips and popovers
    # when Turbo renders a page, and closes open components before Turbo caches
    # it, so a cached page doesn't come back with a stuck modal or tooltip.
    class StimulusGenerator < ::Rails::Generators::Base
      CONTROLLERS = "app/javascript/controllers".freeze
      IMPORTMAP = "config/importmap.rb".freeze

      source_root File.expand_path("../templates", __FILE__)
      desc "Writes a Stimulus controller that keeps Bootstrap's JavaScript working with Turbo"

      def require_stimulus
        return if File.directory?(File.join(destination_root, CONTROLLERS))

        raise ::Rails::Generators::Error,
          "#{CONTROLLERS} does not exist. Install Stimulus first (`bundle add stimulus-rails && bin/rails stimulus:install`)."
      end

      def write_controller
        template "bootstrap_controller.js.tt", "#{CONTROLLERS}/bootstrap_controller.js"
      end

      def explain
        say %(Add data-controller="bootstrap" to <body> in your layout, so it covers every page.)
        return unless manual_registration?

        say "Your controllers are registered by hand. Run `bin/rails stimulus:manifest:update`, " \
            "or register BootstrapController in #{CONTROLLERS}/index.js."
      end

      private

      # Importmap apps import the ES module build; everything else gets the
      # global that the bundle (vendored or CDN) defines.
      def import_bootstrap?
        path = File.join(destination_root, IMPORTMAP)
        File.exist?(path) && File.read(path).match?(/^\s*pin\s+["']bootstrap["']/)
      end

      def manual_registration?
        index = File.join(destination_root, CONTROLLERS, "index.js")
        File.exist?(index) && File.read(index).include?("application.register(")
      end
    end
  end
end
