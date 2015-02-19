module TwitterBreadcrumbsHelper
  def render_breadcrumbs(options = {}, &block)
    default_options = { :separator => '', :class => '', :item_class => '', :divider_class => '', :active_class => 'active' }.merge(options)
    content = render :partial => 'twitter-bootstrap/breadcrumbs', :layout => false, :locals => { options: default_options }
    if block_given?
      capture(content, &block)
    else
      content
    end
  end
end
