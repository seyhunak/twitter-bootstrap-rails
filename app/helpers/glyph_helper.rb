module GlyphHelper
  # ==== Examples
  # glyph(:share_alt)
  # # => <i class="icon-share-alt"></i>
  # glyph(:lock, :white)
  # # => <i class="icon-lock icon-white"></i>
  # glyph(:thumbs_up, :pull_left)
  # # => <i class="icon-thumbs-up pull-left"></i>
  # glyph(:lock, {tag: :span})
  # # => <span class="icon-lock"></span>

  def glyph(*names, options)
    names.map! { |name| name.to_s.gsub('_','-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "icon-#{name}"
    end
    options[:tag] = options[:tag] ||= :i
    content_tag options[:tag], nil, :class => names
  end
end
