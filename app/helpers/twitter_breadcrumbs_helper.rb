module TwitterBreadcrumbsHelper
  def render_breadcrumbs(divider = '/', options={}, &block)
    default_options = { :class => '', :item_class => '', :divider_class => '' }.merge(options)
    content = render :partial => 'twitter-bootstrap/breadcrumbs', :layout => false, :locals => { :divider => divider }
    if block_given?
      capture(content, &block)
    else
      content
    end
  end
end
