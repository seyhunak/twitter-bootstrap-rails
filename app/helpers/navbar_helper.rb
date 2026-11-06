#Credit for this goes to https://github.com/julescopeland/Rails-Bootstrap-Navbar
module NavbarHelper
  def nav_bar(options={}, &block)
    nav_bar_nav(options) do
      container_div(options[:brand], options[:brand_link], options[:responsive], options[:fluid], options[:no_turbolink]) do
        yield if block_given?
      end
    end
  end

  def menu_group(options={}, &block)
    pull_class = { :left => "me-auto", :right => "ms-auto" }[options[:pull].to_s.to_sym]
    content_tag(:ul, :class => ["navbar-nav", pull_class].compact.join(" "), &block)
  end

  def menu_item(name=nil, path="#", *args, &block)
    path = name || path if block_given?
    options = args.extract_options!
    active = is_active?(path, options)
    link_options = options.merge(:class => menu_link_class(active, options[:class]))
    link_options["aria-current"] = "page" if active

    content_tag :li, :class => (@_inside_drop_down ? nil : "nav-item") do
      if block_given?
        link_to path, link_options, &block
      else
        link_to name, path, link_options
      end
    end
  end

  def drop_down(name)
    content_tag :li, :class => "nav-item dropdown" do
      drop_down_link(name) + drop_down_list { yield }
    end
  end

  def drop_down_with_submenu(name, &block)
    content_tag :li, :class => "nav-item dropdown" do
      drop_down_link(name) + drop_down_sublist(&block)
    end
  end

  def drop_down_sublist(&block)
    drop_down_list(&block)
  end

  # Bootstrap 5 has no nested dropdowns, so a submenu renders as a labelled
  # group of items inside its parent menu.
  def drop_down_submenu(name, &block)
    safe_join([drop_down_header(name), inside_drop_down { capture(&block) }])
  end

  def drop_down_divider
    content_tag(:li) { tag.hr(:class => "dropdown-divider") }
  end

  def drop_down_header(text)
    content_tag(:li) { content_tag(:h6, text, :class => "dropdown-header") }
  end

  def menu_divider
    content_tag :li, :class => "nav-item py-1" do
      content_tag :div, "", :class => "vr d-none d-lg-flex h-100 mx-lg-2"
    end
  end

  def menu_text(text=nil, options={}, &block)
    pull       = options.delete(:pull)
    pull_class = { :left => "me-auto", :right => "ms-auto" }[pull.to_s.to_sym]
    options.append_merge!(:class, pull_class)
    options.append_merge!(:class, "navbar-text")
    content_tag :span, options do
      text || yield
    end
  end

  # Returns current url or path state (useful for buttons).
  # Example:
  #   # Assume we'r currently at blog/categories/test
  #   uri_state('/blog/categories/test', {})               # :active
  #   uri_state('/blog/categories', {})                    # :chosen
  #   uri_state('/blog/categories/test', {method: delete}) # :inactive
  #   uri_state('/blog/categories/test/3', {})             # :inactive
  def uri_state(uri, options={})
    return options[:status] if options.key?(:status)

    root_url = request.host_with_port + '/'
    root = uri == '/' || uri == root_url

    request_uri = if uri.start_with?(root_url)
      request.url
    else
      request.path
    end

    if !options[:method].nil? || !options["data-method"].nil?
      :inactive
    elsif uri == request_uri || (options[:root] && (request_uri == '/') || (request_uri == root_url))
      :active
    else
      if request_uri.start_with?(uri) and not(root)
        :chosen
      else
        :inactive
      end
    end
  end

  private

  def nav_bar_nav(options, &block)
    position = "fixed-#{options[:fixed].to_s}" if options[:fixed]
    inverse = options[:inverse] == true
    # :static needs no class: Bootstrap 5 navbars are static unless told otherwise.

    content_tag :nav,
                :class => nav_bar_css_class(position, inverse, options[:responsive] == true),
                "data-bs-theme" => (inverse ? "dark" : nil),
                :role => "navigation" do
      yield
    end
  end

  def container_div(brand, brand_link, responsive, fluid, no_turbolink, &block)
    div_container_class = fluid ? "container-fluid" : "container"
    no_turbolink ||= false

    content_tag :div, :class => div_container_class do
      container_div_with_block(brand, brand_link, responsive, no_turbolink, &block)
    end
  end

  def container_div_with_block(brand, brand_link, responsive, no_turbolink, &block)
    output = []
    output << brand_link(brand, brand_link, no_turbolink)
    if responsive == true
      output << responsive_button
      output << responsive_div { capture(&block) }
    else
      output << capture(&block)
    end
    output.join("\n").html_safe
  end

  def nav_bar_css_class(position, inverse = false, responsive = false)
    css_class = ["navbar", responsive ? "navbar-expand-lg" : "navbar-expand"]
    css_class << (inverse ? "bg-dark" : "bg-body-tertiary")
    css_class << position if position.present?
    css_class.join(" ")
  end

  def brand_link(name, url, no_turbolink)
    return "" if name.blank?
    url ||= root_url

    if no_turbolink
      link_to(name, url, :class => "navbar-brand", :data => { :no_turbolink => true})
    else
      link_to(name, url, :class => "navbar-brand")
    end
  end

  def responsive_button
    %{<button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target=".navbar-collapse" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
      </button>}
  end

  def responsive_div(&block)
    content_tag(:div, :class => "collapse navbar-collapse", &block)
  end

  def is_active?(path, options={})
    state = uri_state(path, options)
    "active" if state.in?([:active, :chosen]) || state === true
  end

  def menu_link_class(active, extra)
    [@_inside_drop_down ? "dropdown-item" : "nav-link", active, extra].compact.join(" ")
  end

  def drop_down_link(name)
    link_to(name, "#", :class => "nav-link dropdown-toggle", :role => "button",
            "data-bs-toggle" => "dropdown", "aria-expanded" => "false")
  end

  def drop_down_list(&block)
    content_tag(:ul, :class => "dropdown-menu") { inside_drop_down(&block) }
  end

  # Bootstrap 5 styles a link differently inside a dropdown, so menu_item has to
  # know where it is being rendered.
  def inside_drop_down
    previous = @_inside_drop_down
    @_inside_drop_down = true
    yield
  ensure
    @_inside_drop_down = previous
  end
end

class Hash
  # appends a string to a hash key's value after a space character (Good for merging CSS classes in options hashes)
  def append_merge!(key, value)
    # just return self if value is blank
    return self if value.blank?

    current_value = self[key]
    # just merge if it doesn't already have that key
    self[key] = value and return if current_value.blank?
    # raise error if we're trying to merge into something that isn't a string
    raise ArgumentError, "Can only merge strings" unless current_value.is_a?(String)
    self[key] = [current_value, value].compact.join(" ")
  end
end
