module TwitterBreadcrumbsHelper
<<<<<<< HEAD
  def render_breadcrumbs(&block)
    content = render :partial => 'twitter-bootstrap/breadcrumbs', :layout => false
=======
  def render_breadcrumbs(divider = '/', options={}, &block)
    default_options = { :class => '', :item_class => '', :divider_class => '', :active_class => 'active' }.merge(options)
    content = render :partial => 'twitter-bootstrap/breadcrumbs', :layout => false, :locals => { :divider => divider, options: options }
>>>>>>> c457371fe4c06bd284a97d737a4d50bbcd266a2a
    if block_given?
      capture(content, &block)
    else
      content
    end
  end
end
