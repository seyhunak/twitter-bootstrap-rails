module TwitterBreadcrumbsHelper
  def render_bootstrap_breadcrumbs(divider = '/', options={}, &block)
    default_options = { :class => '', :item_class => '', :active_class => 'active' }.merge(options)
    content = render :partial => 'twitter-bootstrap/breadcrumbs', :layout => false, :locals => { :divider => divider, options: default_options }
    if block_given?
      capture(content, &block)
    else
      content
    end
  end

  # Add backward compatible alias unless BC on rails present
  alias_method :render_breadcrumbs, :render_bootstrap_breadcrumbs unless defined?(::BreadcrumbsOnRails)
end
