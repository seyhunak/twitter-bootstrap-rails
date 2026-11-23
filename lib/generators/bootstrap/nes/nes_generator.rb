require 'json'
require 'rails/generators'
require 'twitter/bootstrap/rails/version'

module Bootstrap
  module Generators
    # Points an npm-based app (jsbundling-rails / cssbundling-rails) at HeroDevs
    # Bootstrap NES 4.6: security-patched Bootstrap 4 for apps that can't move to 5
    # yet. NES is a paid product from a private registry, so nothing is vendored.
    # The access token stays in an environment variable and never touches a file.
    # Never prompts, so agents and CI can run it.
    class NesGenerator < ::Rails::Generators::Base
      NES = Twitter::Bootstrap::Rails::BOOTSTRAP_NES
      PACKAGE_JSON = "package.json".freeze
      NPMRC = ".npmrc".freeze

      desc "Sets up HeroDevs Bootstrap NES #{NES[:bootstrap_version]} (paid, security-patched Bootstrap 4.6) through npm"

      class_option :'token-env', :type => :string, :default => NES[:token_env],
                   :desc => 'Environment variable that holds the HeroDevs access token'

      def require_package_json
        return if File.exist?(app_path(PACKAGE_JSON))

        raise ::Rails::Generators::Error,
          "Bootstrap NES is installed with npm, but #{PACKAGE_JSON} does not exist. Set up jsbundling-rails or " \
          "cssbundling-rails first (`bin/rails javascript:install:esbuild` or `css:install:bootstrap`)."
      end

      def update_package_json
        json = JSON.parse(File.read(app_path(PACKAGE_JSON)))
        (json["dependencies"] ||= {})["bootstrap"] = alias_spec
        # The override makes packages that depend on bootstrap get NES too.
        (json["overrides"] ||= {})["bootstrap"] = { "." => alias_spec }

        create_file PACKAGE_JSON, JSON.pretty_generate(json) + "\n", :force => true
      end

      def update_npmrc
        lines = File.exist?(app_path(NPMRC)) ? File.read(app_path(NPMRC)).lines.map(&:chomp) : []
        lines << scope_line unless lines.any? { |line| line.start_with?("@neverendingsupport:registry=") }
        lines << auth_line unless lines.any? { |line| line.start_with?("#{registry_key}:_authToken=") }

        create_file NPMRC, lines.join("\n") + "\n", :force => true
      end

      def add_initializer
        create_file "config/initializers/bootstrap.rb", <<~RUBY, :force => true
          # Bootstrap comes from #{NES[:name]} #{NES[:bootstrap_version]} through npm
          # (package.json and .npmrc). `rails g bootstrap:doctor` checks that setup, and the
          # gem's generators warn that they write Bootstrap 5 markup.
          Twitter::Bootstrap::Rails.asset_mode = :nes
        RUBY
      end

      def next_steps
        say <<~TEXT

          #{NES[:name]} #{NES[:bootstrap_version]} is set up in #{PACKAGE_JSON} and #{NPMRC}. Next:

          1. Get an access token from HeroDevs (a paid NES subscription; see #{NES[:docs]}).
          2. Export it where npm runs, locally and in CI:  export #{token_env}=...
             #{NPMRC} reads it from that variable, so don't commit the token.
          3. Run `npm install` (or yarn / bun).
          4. Bootstrap 4's JavaScript needs jQuery; the bundle includes Popper 1. Import
             jQuery before Bootstrap in your JavaScript entry point.

          This gem's layout, themed and snippet generators and its view helpers write
          Bootstrap 5 markup, which doesn't work on Bootstrap 4. Run `rails g bootstrap:doctor`
          to check the NES setup, and `rails g bootstrap:agent` so coding agents know.
        TEXT
      end

      private

      def alias_spec
        "npm:#{NES[:package]}@#{NES[:version]}"
      end

      def registry_key
        NES[:registry].sub(%r{\Ahttps?:}, "")
      end

      def scope_line
        "@neverendingsupport:registry=#{NES[:registry]}"
      end

      def auth_line
        "#{registry_key}:_authToken=${#{token_env}}"
      end

      def token_env
        options[:'token-env']
      end

      def app_path(relative)
        File.join(destination_root, relative)
      end
    end
  end
end
