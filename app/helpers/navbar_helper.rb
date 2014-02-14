#Credit for this goes to https://github.com/julescopeland/Rails-Bootstrap-Navbar
module NavbarHelper
  def nav_bar(options={}, &block)
    nav_bar_div(options) do
      navbar_inner_div do
        container_div(options[:brand], options[:brand_link], options[:brand_html_left], options[:brand_html_right], options[:responsive], options[:fluid]) do
          yield if block_given?
        end
      end
    end
  end

  def menu_group(options={}, &block)
    pull_class = "pull-#{options[:pull].to_s}" if options[:pull].present?
    content_tag(:ul, :class => "nav #{pull_class}", &block)
  end

  def menu_item(name=nil, path="#", *args, &block)
    path = name || path if block_given?
    options = args.extract_options!
    content_tag :li, :class => is_active?(path, options) do
      name, path = path, options if block_given?
      link_to name, path, options, &block
    end
  end

  def drop_down(name)
    content_tag :li, :class => "dropdown" do
      drop_down_link(name) + drop_down_list { yield }
    end
  end

  def drop_down_with_submenu(name, &block)
    content_tag :li, :class => "dropdown" do
      drop_down_link(name) + drop_down_sublist(&block)
    end
  end

  def drop_down_sublist(&block)
    content_tag :ul, :class => "dropdown-menu", &block
  end

  def drop_down_submenu(name, &block)
    content_tag :li, :class => "dropdown-submenu" do
      link_to(name, "") + drop_down_list(&block)
    end
  end

  def drop_down_divider
    content_tag :li, "", :class => "divider"
  end

  def drop_down_header(text)
    content_tag :li, text, :class => "nav-header"
  end

  def menu_divider
    content_tag :li, "", :class => "divider-vertical"
  end

  def menu_text(text=nil, options={}, &block)
    pull       = options.delete(:pull)
    pull_class = pull.present? ? "pull-#{pull.to_s}" : nil
    options.append_merge!(:class, pull_class)
    options.append_merge!(:class, "navbar-text")
    content_tag :p, options do
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

  def nav_bar_div(options, &block)

    position = "static-#{options[:static].to_s}" if options[:static]
    position = "fixed-#{options[:fixed].to_s}" if options[:fixed]
    inverse = (options[:inverse].present? && options[:inverse] == true) ? true : false

    content_tag :div, :class => nav_bar_css_class(position, inverse) do
      yield
    end
  end

  def navbar_inner_div(&block)
    content_tag :div, :class => "navbar-inner" do
      yield
    end
  end

  def container_div(brand, brand_link, brand_html_left, brand_html_right, responsive, fluid, &block)
    content_tag :div, :class => "container#{"-fluid" if fluid}" do
      container_div_with_block(brand, brand_link, brand_html_left, brand_html_right, responsive, &block)
    end
  end

  def container_div_with_block(brand, brand_link, brand_html_left, brand_html_right, responsive, &block)
    output = []
    if responsive == true
      output << responsive_button
      output << brand_link(brand, brand_link, brand_html_left, brand_html_right)
      output << responsive_div { capture(&block) }
    else
      output << brand_link(brand, brand_link, brand_html_left, brand_html_right)
      output << capture(&block)
    end
    output.join("\n").html_safe
  end

  def nav_bar_css_class(position, inverse = false)
    css_class = ["navbar"]
    css_class << "navbar-#{position}" if position.present?
    css_class << "navbar-inverse" if inverse
    css_class.join(" ")
  end

  def brand_link(name, url, brand_html_left, brand_html_right)
    return "" if name.blank?
    url ||= root_url

    output = []
    output << '<div class="brand_html_left">' + brand_html_left + '</div>' if brand_html_left
    output << link_to(name, url, :class => "brand")
    output << '<div class="brand_html_right">' + brand_html_right + '</div>' if brand_html_right
    output.join("\n").html_safe
  end

  def responsive_button
    %{<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </a>}
  end

  def responsive_div(&block)
    content_tag(:div, :class => "nav-collapse collapse", &block)
  end

  def is_active?(path, options={})
    state = uri_state(path, options)
    "active" if state.in?([:active, :chosen]) || state === true
  end

  def name_and_caret(name)
    "#{name} #{content_tag(:b, :class => "caret") {}}".html_safe
  end

  def drop_down_link(name)
    link_to(name_and_caret(name), "#", :class => "dropdown-toggle", "data-toggle" => "dropdown")
  end

  def drop_down_list(&block)
    content_tag :ul, :class => "dropdown-menu", &block
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
