module ModalHelper

  #modals have a header, a body, a footer for options.
  def modal_dialog(options = {}, &block)
    content_tag :div, :id => options[:id], :class => "modal fade" do
      content_tag :div, :class => "modal-dialog" do
        content_tag :div, :class => "modal-content" do
          modal_header(options[:header]) +
          modal_body(options[:body]) +
          modal_footer(options[:footer])
        end
      end
    end
  end

  def modal_header(options = {}, &block)
    content_tag :div, :class => 'modal-header' do
      if options[:show_close] 
        close_button(options[:dismiss]) +
        content_tag(:h4, options[:title], :class => 'modal-title', &block)
      else
        content_tag(:h4, options[:title], :class => 'modal-title', &block)
      end	
    end
  end

  def modal_body(options = {}, &block)
    content_tag :div, options, :class => 'modal-body', &block
  end

  def modal_footer(options = {}, &block)
    content_tag :div, options, :class => 'modal-footer', &block
  end

  def close_button(dismiss)
    #It doesn't seem to like content_tag, so we do this instead.	
    raw("<button class=\"close\" data-dismiss=\"#{dismiss}\" aria-hidden=\"true\">&times;</button>")
  end

  def modal_toggle(content_or_options = nil, options = {}, &block)
    if block_given?
      options = content_or_options if content_or_options.is_a?(Hash)
      default_options = { :class => 'btn btn-default', "data-toggle" => "modal", "href" => options[:dialog] }.merge(options)

      content_tag :a, nil, default_options, true, &block
    else
      default_options = { :class => 'btn btn-default', "data-toggle" => "modal", "href" => options[:dialog] }.merge(options)
      content_tag :a, content_or_options, default_options, true
    end
  end

  def modal_cancel_button content, options = {}
    default_options = { :class => "btn bootstrap-modal-cancel-button" }

    content_tag_string "a", content, default_options.merge(options)
  end

end

