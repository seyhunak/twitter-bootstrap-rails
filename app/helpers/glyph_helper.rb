module GlyphHelper
  # ==== Examples
  # glyph(:share_alt)
  # # => <span class="icon-share-alt"></span>
  # glyph(:lock, :white)
  # # => <span class="icon-lock icon-white"></span>
  # glyph(:thumbs_up, :pull_left)
<<<<<<< HEAD
  # # => <span class="icon-thumbs-up pull-left"></span>
=======
  # # => <i class="icon-thumbs-up pull-left"></i>
  # glyph(:lock, {tag: :span})
  # # => <span class="icon-lock"></span>
>>>>>>> c457371fe4c06bd284a97d737a4d50bbcd266a2a

  def glyph(*names, options)
    names.map! { |name| name.to_s.gsub('_','-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "glyphicon glyphicon-#{name}"
    end
<<<<<<< HEAD
    content_tag :span, nil, :class => names
=======
    options[:tag] = options[:tag] ||= :i
    content_tag options[:tag], nil, :class => names
>>>>>>> c457371fe4c06bd284a97d737a4d50bbcd266a2a
  end
end
