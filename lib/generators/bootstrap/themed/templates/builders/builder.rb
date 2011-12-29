class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
              %w{date_select datetime_select time_select} +
              %w{collection_select select country_select time_zone_select} -
              %w{hidden_field label fields_for}

  helpers.each do |name|
    define_method(name) do |field, *args|
      options_index = ActionView::Helpers::FormBuilder.instance_method(name.to_sym).parameters.index([:opt,:options])
      if options_index.nil?
        options = args.last.is_a?(Hash) ? args.pop : {}
      else
        options = args[options_index - 1]
      end
      label = label(field, options[:label], :class => options[:label_class])
      @template.content_tag(:div, :class => 'clearfix') do
        @template.concat(label)
        @template.concat(@template.content_tag(:div, :class => 'input') { @template.concat(super(field, *args)) })
      end
    end
  end
end

ActionView::Base.default_form_builder = BootstrapFormBuilder
