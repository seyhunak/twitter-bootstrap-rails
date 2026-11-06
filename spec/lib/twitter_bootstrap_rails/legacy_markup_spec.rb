require 'spec_helper'
require 'twitter/bootstrap/rails/legacy_markup'

describe Twitter::Bootstrap::Rails::LegacyMarkup do
  def found(text, extension = ".erb")
    described_class.scan(text, extension).map { |f| f[:found] }
  end

  it "reports the line and the replacement" do
    finding = described_class.scan(%{<p>ok</p>\n<a class="btn btn-default">x</a>}, ".erb").first

    expect(finding).to include(:line => 2, :found => "btn-default", :replacement => "btn-secondary")
  end

  it "finds old data attributes" do
    expect(found(%{<a data-toggle="modal" data-target="#m"></a>})).to eq(%w[data-toggle data-target])
  end

  it "leaves Bootstrap 5 data attributes alone" do
    expect(found(%{<a data-bs-toggle="modal" data-bs-target="#m"></a>})).to be_empty
  end

  it "finds old data attributes in Ruby hashes" do
    expect(found(%{<%= link_to "x", "#", data: { toggle: "modal" } %>})).to eq(%w[data-toggle])
    expect(found(%{<%= link_to "x", "#", :data => { :dismiss => "modal" } %>})).to eq(%w[data-dismiss])
  end

  it "finds old classes in each Ruby hash style" do
    expect(found(%{<%= link_to "x", "#", class: "btn btn-default" %>})).to eq(%w[btn-default])
    expect(found(%{<%= link_to "x", "#", :class => 'btn-xs' %>})).to eq(%w[btn-xs])
  end

  it "ignores interpolated code inside a class attribute" do
    expect(found('<div class="<%= close %> #{well}"></div>')).to be_empty
  end

  it "matches whole class names only" do
    expect(found(%{<div class="my-panel closed wells"></div>})).to be_empty
  end

  it "ignores the same words outside class attributes" do
    expect(found(%{<p>Close the panel, it went well.</p>})).to be_empty
  end

  it "rewrites numbered classes" do
    finding = described_class.scan(%{<div class="col-xs-6 ml-3 pr-md-2"></div>}, ".erb")

    expect(finding.map { |f| f[:replacement] }).to eq(%w[col-6 ms-3 pe-md-2])
  end

  it "finds class shorthand in Haml and Slim" do
    expect(found("%button.btn.btn-default Save", ".haml")).to eq(%w[btn-default])
    expect(found(".form-group\n  = f.label :x", ".haml")).to eq(%w[form-group])
    expect(found("button.btn-xs Save", ".slim")).to eq(%w[btn-xs])
  end

  it "does not treat plain Haml text as class shorthand" do
    expect(found("Visit example.close today", ".haml")).to be_empty
  end

  # The gem can't tell agents off for markup it ships itself.
  it "finds nothing in the markup this gem ships" do
    root = File.expand_path("../../..", __dir__)
    files = Dir[File.join(root, "lib/generators/**/templates/**/*"), File.join(root, "app/views/**/*"), File.join(root, "app/helpers/**/*")]
            .select { |f| File.file?(f) }

    offenders = files.flat_map do |file|
      described_class.scan(File.read(file), File.extname(file))
                     .map { |f| "#{file.sub("#{root}/", '')}:#{f[:line]} #{f[:found]}" }
    end

    expect(offenders).to eq([])
  end
end
