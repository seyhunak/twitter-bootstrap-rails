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
    content_tag :span, value, :class => "#{klass.join(' ')}"
  end
end
