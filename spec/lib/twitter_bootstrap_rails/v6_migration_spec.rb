require 'spec_helper'
require 'twitter/bootstrap/rails/v6_migration'

describe Twitter::Bootstrap::Rails::V6Migration do
  def scan(text, extension = ".erb")
    described_class.scan(text, extension)
  end

  def found(text, extension = ".erb")
    scan(text, extension).map { |f| f[:found] }
  end

  def replacements(text, extension = ".erb")
    scan(text, extension).map { |f| f[:replacement] }
  end

  it "reports the line and the replacement" do
    finding = scan(%{<p>ok</p>\n<div class="modal-body">x</div>}).first

    expect(finding).to include(:line => 2, :found => "modal-body", :replacement => "dialog-body")
  end

  it "renames modal, offcanvas and dropdown classes" do
    expect(replacements(%{<div class="offcanvas offcanvas-start dropdown-menu dropdown-item"></div>}))
      .to eq(["drawer on a <dialog> element", "drawer-start", "menu", "menu-item"])
  end

  it "renames components under a breakpoint prefix" do
    expect(replacements(%{<div class="offcanvas-lg dropdown-menu-md-end"></div>})).to eq(%w[lg:drawer md:menu-end])
  end

  it "moves breakpoints to a prefix" do
    expect(replacements(%{<div class="col-md-6 d-lg-none p-sm-3 offset-xxl-2 sticky-md-top"></div>}))
      .to eq(%w[md:col-6 lg:d-none sm:p-3 2xl:offset-2 md:sticky-top])
  end

  it "moves breakpoint suffixes to a prefix" do
    expect(replacements(%{<nav class="navbar navbar-expand-lg"><div class="container-xxl table-responsive-sm"></div></nav>}))
      .to eq(%w[lg:navbar-expand 2xl:container sm:table-responsive])
  end

  it "moves hover and print states to a prefix" do
    expect(replacements(%{<a class="opacity-50-hover link-underline-opacity-75-hover d-print-none"></a>}))
      .to eq(%w[hover:opacity-50 hover:underline-opacity-75 print:d-none])
  end

  it "replaces colour variants with theme classes" do
    expect(replacements(%{<a class="btn btn-primary btn-outline-danger alert-info text-muted text-success"></a>}))
      .to eq(["btn-solid theme-primary", "btn-outline theme-danger", "alert theme-info", "fg-secondary", "fg-success"])
  end

  it "maps font sizes to the t-shirt scale" do
    expect(replacements(%{<p class="fs-1 fs-6"></p>})).to eq(%w[fs-4xl fs-md])
  end

  it "finds renamed toggle values in HTML and Ruby" do
    expect(replacements(%{<button data-bs-toggle="modal" data-bs-dismiss='offcanvas'></button>}))
      .to eq([%{data-bs-toggle="dialog"}, %{data-bs-dismiss="drawer"}])
    expect(replacements(%{<%= link_to "x", "#", data: { bs_toggle: "dropdown" } %>}))
      .to eq([%{data-bs-toggle="menu"}])
    expect(replacements(%{<%= button_tag "x", data: { "bs-dismiss" => "modal" } %>}))
      .to eq([%{data-bs-dismiss="dialog"}])
  end

  it "finds carousel autoplay" do
    expect(found(%{<div class="carousel" data-bs-ride="carousel"></div>})).to eq(%w[data-bs-ride])
  end

  it "finds Sass and JavaScript that changed" do
    expect(found(%{@import "bootstrap/scss/bootstrap";}, ".scss")).to eq([%{@import "bootstrap}])
    expect(found("new bootstrap.Modal(el, { popperConfig: {} })", ".js")).to eq(%w[bootstrap.Modal popperConfig])
    expect(found("color: rgba(var(--bs-primary-rgb), .5);", ".css")).to eq(%w[--bs-primary-rgb])
  end

  it "only reads class names in markup and Ruby files" do
    expect(found(%{const html = '<div class="modal-body">'}, ".js")).to be_empty
  end

  it "finds class shorthand in Haml and Slim" do
    expect(found("%button.btn.btn-primary Save", ".haml")).to eq(%w[btn-primary])
    expect(found(".modal-dialog\n  .modal-content", ".slim")).to eq(%w[modal-dialog modal-content])
  end

  it "leaves Bootstrap 6 markup alone" do
    v6 = %{<dialog class="dialog"><div class="dialog-body md:col-6 btn-solid theme-primary fg-secondary fs-4xl"></div></dialog>}

    expect(found(v6)).to be_empty
    expect(found(%{<button data-bs-toggle="dialog"></button>})).to be_empty
  end

  it "matches whole class names only" do
    expect(found(%{<div class="my-modal modal-bodywork"></div>})).to be_empty
  end

  it "has an example for every pattern, for the agent guide" do
    expect(described_class::CLASS_PATTERNS.map(&:last)).to all(match(/ becomes? /))
  end
end
