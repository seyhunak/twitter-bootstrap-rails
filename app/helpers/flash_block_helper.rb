module FlashBlockHelper
  ALERT_CONTEXTS = { :notice => :success, :alert => :danger, :error => :danger }.freeze unless const_defined?(:ALERT_CONTEXTS)

  def flash_block
    output = ''
    flash.each do |type, message|
      output += flash_container(type, message)
    end

    raw(output)
  end

  def flash_container(type, message)
    context = ALERT_CONTEXTS.fetch(type.to_sym, type)
    close = content_tag(:button, "", :type => "button", :class => "btn-close", "data-bs-dismiss" => "alert", "aria-label" => "Close")

    content_tag(:div, safe_join([message, close]), :class => "alert alert-#{context} alert-dismissible fade show", :role => "alert")
  end
end
