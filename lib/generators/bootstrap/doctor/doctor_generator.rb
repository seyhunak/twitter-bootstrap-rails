require 'json'
require 'rails/generators'
require 'twitter/bootstrap/rails/doctor'

module Bootstrap
  module Generators
    # A generator rather than a rake task because rake rejects flags like --json.
    # Writes nothing. Exits 1 if any check reports an error.
    class DoctorGenerator < ::Rails::Generators::Base
      desc "Checks how Bootstrap is set up in this app and finds markup from older Bootstrap versions"

      class_option :json, :type => :boolean, :default => false,
                   :desc => 'Print the report as JSON'
      class_option :v6, :type => :boolean, :default => false,
                   :desc => 'Also list Bootstrap 5 code that changes in Bootstrap 6'

      def diagnose
        report = Twitter::Bootstrap::Rails::Doctor.new(destination_root).report(:v6 => options[:v6])

        options[:json] ? say(JSON.pretty_generate(report)) : print_report(report)
        exit(1) if report[:status] == "error"
      end

      private

      def print_report(report)
        say "Bootstrap #{report[:bootstrap_version]} on Rails #{report[:rails_version]} " \
            "(#{report[:asset_pipeline]}, #{report[:asset_mode]}, #{report[:template_engine]})\n"

        report[:checks].each do |check|
          say format("%-8s %-20s %s", "[#{check[:status]}]", check[:id], check[:message])
          say "         #{' ' * 20} Fix: #{check[:fix]}" if check[:fix]
        end

        print_findings("Older Bootstrap markup", report[:legacy_markup])
        print_findings("Changes in Bootstrap 6", report[:v6_migration])
      end

      def print_findings(title, findings)
        return if findings.nil? || findings.empty?

        say "\n#{title}:"
        findings.each do |finding|
          say "  #{finding[:file]}:#{finding[:line]}  #{finding[:found]} -> #{finding[:replacement]}"
        end
      end
    end
  end
end
