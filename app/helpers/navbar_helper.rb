module NavbarHelper
  def page_links_for_navigation
    link = Struct.new(:name, :url)
  end

  def navbar(*class_names)
    content_tag(:ul, :class => class_names)
  end

  def navbar_link(link_text, link_path ||= root_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
end
