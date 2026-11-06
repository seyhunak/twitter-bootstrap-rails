module ModalHelper

  #modals have a header, a body, a footer for options.
  def modal_dialog(options = {}, &block)
    options = {:id => 'modal', :size => '', :show_close => true, :dismiss => true}.merge options
    content_tag :div, :class => "bootstrap-modal modal fade", :id => options[:id], :tabindex => "-1", "aria-hidden" => "true" do
      content_tag :div, :class => ["modal-dialog", options[:size].presence].compact.join(" ") do
        content_tag :div, :class => "modal-content" do
          modal_header(options[:header], &block) +
          modal_body(options[:body], &block) +
          modal_footer(options[:footer], &block)
        end
      end
    end
  end

  def modal_header(options, &block)
    content_tag :div, :class => 'modal-header' do
      if options[:show_close]
        content_tag(:h5, options[:title], :class => 'modal-title', &block) +
        close_button(options[:dismiss])
      else
        content_tag(:h5, options[:title], :class => 'modal-title', &block)
      end
    end
  end

  def modal_body(options, &block)
    content_tag :div, options[:content], :class => 'modal-body', :style => options[:style], &block
  end

  def modal_footer(options, &block)
    content_tag :div, options[:content], :class => 'modal-footer', &block
  end

  def close_button(dismiss = "modal")
    dismiss = "modal" if dismiss.blank? || dismiss == true
    content_tag :button, "", :type => "button", :class => "btn-close", "data-bs-dismiss" => dismiss, "aria-label" => "Close"
  end

  def modal_toggle(content_or_options = nil, options, &block)
    if block_given?
      options = content_or_options if content_or_options.is_a?(Hash)
      default_options = { :class => 'btn btn-secondary', "data-bs-toggle" => "modal", "href" => options[:dialog] }.merge(options)

      content_tag :a, nil, default_options, true, &block
    else
      default_options = { :class => 'btn btn-secondary', "data-bs-toggle" => "modal", "href" => options[:dialog] }.merge(options)
      content_tag :a, content_or_options, default_options, true
    end
  end

  def modal_cancel_button(content, options = {})
    default_opts = { :class => "btn btn-secondary bootstrap-modal-cancel-button", "data-bs-dismiss" => "modal" }

    content_tag :a, content, default_opts.merge(options)
  end

end
