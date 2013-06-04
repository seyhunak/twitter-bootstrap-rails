module BadgeLabelHelper
  def badge(*args)
    badge_label(:badge, *args)
  end

  def tag_label(*args)
    badge_label(:label, *args)
  end

  private
  def badge_label(what, value, type = nil)
    klass = [what]
    klass << "#{what}-#{type}" if type.present?

    %{<span class="#{klass.join(' ')}">#{value}</span>}.html_safe
  end
end