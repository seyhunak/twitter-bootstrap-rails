module FormErrorsHelper
  include ActionView::Helpers::FormTagHelper

  def error_span(attribute, options = {})
    options[:span_class] ||= 'help-block'
    options[:error_class] ||= 'has-error'

    if errors_on?(attribute)
      @template.content_tag( :div, :class => options[:error_class] )  do
        content_tag( :span, errors_for(attribute), :class => options[:span_class] )
      end
    end
  end

  def errors_on?(attribute)
    object.errors[attribute].present? if object.respond_to?(:errors)
  end

  def errors_for(attribute)
    object.errors[attribute].try(:join, ', ') || object.errors[attribute].try(:to_s)
  end
end
