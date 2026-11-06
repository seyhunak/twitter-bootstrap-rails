module BootstrapFlashHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash(options = {})
    flash_messages = []
    tag_class = options[:class]
    tag_attributes = options.except(:class)

    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_options = {
        class: ["alert", "alert-#{type}", "alert-dismissible", "fade", "show", tag_class].compact.join(" "),
        role: "alert"
      }.merge(tag_attributes)

      close_button = content_tag(:button, "", type: "button", class: "btn-close", "data-bs-dismiss" => "alert", "aria-label" => "Close")

      Array(message).each do |msg|
        # safe_join, not +: the message comes first now, and String + SafeBuffer
        # would skip escaping it.
        text = content_tag(:div, safe_join([msg, close_button]), tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
