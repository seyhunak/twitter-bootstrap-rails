require 'rails/generators'

module Bootstrap
  module Generators
    class LayoutGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator generates layout file with navigation."
      argument :layout_name, :type => :string, :default => "application"
      argument :layout_type, :type => :string, :default => "fixed",
               :banner => "*fixed or fluid"

      attr_reader :app_name, :container_class

      def add_helper
       if File.exists?(Rails.root.join("app/helpers/application_helper.rb"))
          say "Bootstrap helpers installs to application_helper..."
          insert_into_file "app/helpers/application_helper.rb",
          "  def flash_class(level)\n  case level\n  when :notice then 'info'\n  when :error then 'error'\n  when :alert then 'warning'\n  end\n  end\n", :after => "module ApplicationHelper\n"
       else
          say "Already installed"
       end
      end

      def generate_layout
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        @container_class = layout_type == "fluid" ? "container-fluid" : "container"
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        template "layout.html.#{ext}", "app/views/layouts/#{layout_name}.html.#{ext}"
      end
    end
  end
end
