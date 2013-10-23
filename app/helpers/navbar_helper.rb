#Credit for this goes to https://github.com/julescopeland/Rails-Bootstrap-Navbar
module NavbarHelper
  def nav_bar(options={}, &block)
    nav_bar_nav(options) do
      container_div(options[:brand], options[:brand_link], options[:responsive], options[:fluid]) do
        yield if block_given?
      end
    end
  end

  def menu_group(options={}, &block)
    pull_class = "pull-#{options[:pull].to_s}" if options[:pull].present?
    content_tag(:ul, :class => "nav navbar-nav #{pull_class}", &block)
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
    root_url = request.host_with_port + '/'
    root = uri == '/' || uri == root_url

    request_uri = if uri.start_with?(root_url)
      request.url
    else
      request.path
    end

    if !options[:method].nil? || !options["data-method"].nil?
      :inactive
    elsif uri == request_uri
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

    position = "static-#{options[:static].to_s}" if options[:static]
    position = "fixed-#{options[:fixed].to_s}" if options[:fixed]
    inverse = (options[:inverse].present? && options[:inverse] == true) ? true : false

    content_tag :nav, :class => nav_bar_css_class(position, inverse), :role => "navigation" do
      yield
    end
  end

  def container_div(brand, brand_link, responsive, fluid, &block)
    content_tag :div, :class => "container" do
      container_div_with_block(brand, brand_link, responsive, &block)
    end
  end

  def container_div_with_block(brand, brand_link, responsive, &block)
    output = []
    if responsive == true
      output << responsive_nav_header(brand, brand_link)
      output << responsive_div { capture(&block) }
    else
      output << brand_link(brand, brand_link)
      output << capture(&block)
    end
    output.join("\n").html_safe
  end

  def responsive_nav_header(brand, brand_link)
    content_tag(:div, :class => "navbar-header") do
      output = []
      output << responsive_button
      output << brand_link(brand, brand_link)
      output.join("\n").html_safe
    end
  end

  def nav_bar_css_class(position, inverse = false)
    css_class = ["navbar", "navbar-default"]
    css_class << "navbar-#{position}" if position.present?
    css_class << "navbar-inverse" if inverse
    css_class.join(" ")
  end

  def brand_link(name, url)
    return "" if name.blank?
    url ||= root_url
    link_to(name, url, :class => "navbar-brand")
  end

  def responsive_button
    %{<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
          <span class="sr-only">Toggle navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>}
  end

  def responsive_div(&block)
    content_tag(:div, :class => "navbar-collapse collapse", &block)
  end

  def is_active?(path, options={})
    "active" if uri_state(path, options).in?([:active, :chosen])
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
