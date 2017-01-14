module GlyphHelper
  # ==== Examples
  # glyph(:share_alt)
  # # => <span class="icon-share-alt"></span>
  # glyph(:lock, :white)
  # # => <span class="icon-lock icon-white"></span>
  # glyph(:thumbs_up, :pull_left)
  # # => <i class="icon-thumbs-up pull-left"></i>
  # glyph(:lock, {tag: :span})
  # # => <span class="icon-lock"></span>
  # glyph(:lock, {class: 'foo'})
  # # => <i class="icon-lock foo"></i>
  def glyph(*names)
    options = names.last.kind_of?(Hash) ? names.pop : {}
    names.map! { |name| name.to_s.tr('_', '-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "glyphicon glyphicon-#{name}"
    end
    options[:tag] = options[:tag] ||= :i
    names.push options[:class] || ''
    content_tag options[:tag], nil, class: names
  end
end
