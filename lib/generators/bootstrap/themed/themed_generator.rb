require 'rails/generators'
require 'rails/generators/generated_attribute'

module Bootstrap
  module Generators
    class ThemedGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :controller_path,    :type => :string
      argument :model_name,         :type => :string, :required => false
      argument :layout,             :type => :string, :default => "application",
                                    :banner => "Specify application layout"

      class_option :excluded_columns, :type => :array, :required => false

      def initialize(args, *options)
        super(args, *options)
        initialize_views_variables
      end

      def copy_views
        generate_views
      end

      protected

      def initialize_views_variables
        @base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(controller_path)
        @controller_routing_path = @controller_file_path.gsub(/\//, '_')
        @model_name = @controller_class_nesting + "::#{@base_name.singularize.camelize}" unless @model_name
        @model_name = @model_name.camelize
      end

      def controller_routing_path
        @controller_routing_path
      end

      def singular_controller_routing_path
        @controller_routing_path.singularize
      end

      def model_name
        @model_name
      end

      def plural_model_name
        @model_name.pluralize
      end

      def resource_name
        @model_name.demodulize.underscore
      end

      def plural_resource_name
        resource_name.pluralize
      end

      def columns
        retrieve_columns.reject {|c| excluded?(c.name) }.map do |c|
          new_attribute(c.name, c.type.to_s)
        end
      end

      def excluded_columns_names
        %w[id created_at updated_at]
      end

      def excluded_columns_pattern
        [
          /.*_checksum/,
          /.*_count/,
        ]
      end

      def excluded_columns
        options['excluded_columns']||[]
      end

      def excluded?(name)
        excluded_columns_names.include?(name) ||
        excluded_columns_pattern.any? {|p| name =~ p } ||
        excluded_columns.include?(name)
      end

      def retrieve_columns
        if defined?(ActiveRecord) == "constant" && ActiveRecord.class == Module 
          rescue_block ActiveRecord::StatementInvalid do
            @model_name.constantize.columns
          end
        else
          rescue_block do
            @model_name.constantize.fields.map {|c| c[1] }
          end
        end
      end

      def new_attribute(name, type)
        ::Rails::Generators::GeneratedAttribute.new(name, type)
      end

      def rescue_block(exception=Exception)
        yield if block_given?
      rescue exception => e
        say e.message, :red
        exit
      end

      def extract_modules(name)
        modules = name.include?('/') ? name.split('/') : name.split('::')
        name    = modules.pop
        path    = modules.map { |m| m.underscore }
        file_path = (path + [name.underscore]).join('/')
        nesting = modules.map { |m| m.camelize }.join('::')
        [name, path, file_path, nesting, modules.size]
      end

      def generate_views
        options.engine == generate_erb(selected_views)
      end

      def selected_views
        {
          "index.html.#{ext}"                 => File.join('app/views', @controller_file_path, "index.html.#{ext}"),
          "new.html.#{ext}"                   => File.join('app/views', @controller_file_path, "new.html.#{ext}"),
          "edit.html.#{ext}"                  => File.join('app/views', @controller_file_path, "edit.html.#{ext}"),
          "#{form_builder}_form.html.#{ext}"  => File.join('app/views', @controller_file_path, "_form.html.#{ext}"),
          "show.html.#{ext}"                  => File.join('app/views', @controller_file_path, "show.html.#{ext}")
        }
      end

      def generate_erb(views)
        views.each do |template_name, output_path|
          template template_name, output_path
        end
      end

      def ext
        ::Rails.application.config.generators.options[:rails][:template_engine] || :erb
      end

      def form_builder
        defined?(::SimpleForm) ? 'simple_form/' : ''
      end
    end
  end
end



