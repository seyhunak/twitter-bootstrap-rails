module BadgeLabelHelper
  def badge(*args)
    badge_label(*args)
  end

  # Bootstrap 4 merged labels into badges, so this renders a badge too.
  def tag_label(*args)
    badge_label(*args)
  end

  private
  def badge_label(value, type = nil)
    content_tag :span, value, :class => "badge text-bg-#{type.presence || 'secondary'}"
  end
end
