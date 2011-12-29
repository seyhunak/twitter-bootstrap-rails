require 'rails/generators'
require 'rails/generators/generated_attribute'

module Bootstrap
  module Generators
    class ThemedGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :controller_path,    :type => :string
      argument :model_name,         :type => :string, :required => false
      argument :layout,             :type => :string, :default => "application",
                                    :banner => "Specify application layout"

      def initialize(args, *options)
        super(args, *options)
        initialize_views_variables
      end

      def copy_form_builder
        copy_file "builders/builder.rb", "app/form_builders/bootstrap_form_builder.rb"
      end

      def copy_helper
       if File.exist?('app/helpers/application_helper.rb')
	      insert_into_file "app/helpers/application_helper.rb","  def bootstrap_form_for(object, options = {}, &block)
    options[:builder] = BootstrapFormBuilder
    form_for(object, options, &block)
  end\n", :after => "module ApplicationHelper\n"
	      else
	      copy_file "builders/helper.rb", "app/helpers/application_helper.rb"
	      end
  	  end

  	  def copy_views
        generate_views
        gsub_file(File.join('app/views/layouts', "#{layout}.html.erb"), /\<ul\s+class=\"nav\">.*\<\/ul\>/mi) do |match|
          match.gsub!(/\<\/ul\>/, "")
            %|#{match} <li class="<%= controller.controller_path == '#{@controller_file_path}' ? 'active' : '' %>"><a href="<%= #{controller_routing_path}_path %>">#{plural_model_name}</a></li></ul>|
          end
      end

      protected

      def initialize_views_variables
        @base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(controller_path)
        @controller_routing_path = @controller_file_path.gsub(/\//, '_')
        @model_name = @base_name.singularize unless @model_name
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
        @model_name.underscore
      end

      def plural_resource_name
        resource_name.pluralize
      end

      def columns
        begin
          excluded_column_names = %w[id created_at updated_at]
          Kernel.const_get(@model_name).columns.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| Rails::Generators::GeneratedAttribute.new(c.name, c.type)}
        rescue NoMethodError
          Kernel.const_get(@model_name).fields.collect{|c| c[1]}.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| Rails::Generators::GeneratedAttribute.new(c.name, c.type.to_s)}
        end
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
        views = {
          'index.html.erb'   => File.join('app/views', @controller_file_path, "index.html.erb"),
          'new.html.erb'     => File.join('app/views', @controller_file_path, "new.html.erb"),
          'edit.html.erb'    => File.join('app/views', @controller_file_path, "edit.html.erb"),
          '_form.html.erb'   => File.join('app/views', @controller_file_path, "_form.html.erb"),
          'show.html.erb'    => File.join('app/views', @controller_file_path, "show.html.erb")}
        selected_views = views
        options.engine == generate_erb(selected_views)
      end

      def generate_erb(views)
        views.each do |template_name, output_path|
          template template_name, output_path
        end
      end

    end
  end
end
