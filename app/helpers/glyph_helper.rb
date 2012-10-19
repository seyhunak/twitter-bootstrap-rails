module GlyphHelper
  # ==== Examples
  # glyph(:share_alt)
  # # => <i class="icon-share-alt"></i>
  # glyph(:lock, :white)
  # # => <i class="icon-lock icon-white"></i>

  def glyph(*names)
    content_tag :i, nil, :class => names.map{|name| "icon-#{name.to_s.gsub('_','-')}" }
  end
end

