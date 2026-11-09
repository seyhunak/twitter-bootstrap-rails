require 'erb'
require 'rails/generators'
require 'twitter/bootstrap/rails/doctor'
require 'twitter/bootstrap/rails/v6_migration'
require 'generators/bootstrap/snippets/snippet_catalog'

module Bootstrap
  module Generators
    # Writes a guide for coding agents, tailored to this app and built from the
    # same catalog and tables the other commands use, so it can't drift from them.
    class AgentGenerator < ::Rails::Generators::Base
      SKILL_PATH = ".claude/skills/bootstrap-rails/SKILL.md".freeze
      AGENTS_PATH = "AGENTS.md".freeze
      SECTION_START = "<!-- bootstrap-rails:start -->".freeze
      SECTION_END = "<!-- bootstrap-rails:end -->".freeze
      SKILL_DESCRIPTION = "Use when adding or changing Bootstrap UI, layouts or styles in this Rails app. " \
                          "Covers the twitter-bootstrap-rails generators, helpers and checks.".freeze

      source_root File.expand_path("../templates", __FILE__)
      desc "Writes a guide for coding agents: a Claude skill and a section in AGENTS.md"

      class_option :claude, :type => :boolean, :default => true,
                   :desc => "Write #{SKILL_PATH}"
      class_option :agents, :type => :boolean, :default => true,
                   :desc => "Write a section into #{AGENTS_PATH}, keeping the rest of the file"

      def write_skill
        return unless options[:claude]

        frontmatter = "---\nname: bootstrap-rails\ndescription: #{SKILL_DESCRIPTION}\n---\n\n"
        # :force because this file is entirely generated, and a conflict prompt
        # would hang an agent running the command.
        create_file SKILL_PATH, frontmatter + guide, :force => true
      end

      def write_agents_section
        return unless options[:agents]

        section = "#{SECTION_START}\n#{guide}#{SECTION_END}\n"
        path = File.join(destination_root, AGENTS_PATH)
        existing = File.exist?(path) ? File.read(path) : nil

        if existing.nil?
          create_file AGENTS_PATH, section
        elsif existing.include?(SECTION_START)
          gsub_file(AGENTS_PATH, /#{Regexp.escape(SECTION_START)}.*?#{Regexp.escape(SECTION_END)}\n?/m) { section }
        else
          append_to_file AGENTS_PATH, "\n#{section}"
        end
      end

      private

      def guide
        @guide ||= ERB.new(File.read(File.join(self.class.source_root, "guide.md.erb")), :trim_mode => "-").result(binding)
      end

      def facts
        @facts ||= Twitter::Bootstrap::Rails::Doctor.new(destination_root).facts
      end

      def catalog
        SnippetCatalog
      end

      def legacy
        Twitter::Bootstrap::Rails::LegacyMarkup
      end

      def v6
        Twitter::Bootstrap::Rails::V6Migration
      end

      def pipeline_note
        case facts[:asset_pipeline]
        when "propshaft"
          "Propshaft. It has no `require` directives, so the layout has to link Bootstrap's files by name."
        when "sprockets"
          "Sprockets. Bootstrap loads through Sprockets directives in the application manifests."
        else
          "Not detected. Run `rails g bootstrap:doctor` after installing an asset pipeline."
        end
      end
    end
  end
end
