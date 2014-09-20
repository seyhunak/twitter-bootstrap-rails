module IconHelper
  # ==== Examples
  # icon(:share_alt)
  # # => <span class="icon-share-alt"></span>
  # icon(:lock, :white)
  # # => <span class="icon-lock icon-white"></span>
  # icon(:thumbs_up, :pull_left)
  # # => <i class="icon-thumbs-up pull-left"></i>
  # icon(:lock, {tag: :span})
  # # => <span class="icon-lock"></span>
  def icon(*names)
    options = (names.last.kind_of?(Hash)) ? names.pop : {}
    names.map! { |name| name.to_s.gsub('_','-') }
    names.map! do |name|
      name =~ /pull-(?:left|right)/ ? name : "fa fa-#{name}"
    end
    options[:tag] = options[:tag] ||= :i
    content_tag options[:tag], nil, :class => names
  end
end
