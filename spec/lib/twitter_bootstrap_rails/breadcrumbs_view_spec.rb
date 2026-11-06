require 'spec_helper'
require_relative '../../../app/helpers/twitter_breadcrumbs_helper'

describe "twitter-bootstrap/_breadcrumbs" do
  let(:crumbs) do
    [{ :name => "Home", :url => "/", :options => {} },
     { :name => "Tasks", :url => "/tasks", :options => {} }]
  end

  let(:view) do
    views = File.expand_path("../../../app/views", __dir__)
    ActionView::Base.with_empty_template_cache
                    .with_view_paths([views], { "__bs_breadcrumbs" => crumbs })
                    .tap { |v| v.extend(TwitterBreadcrumbsHelper) }
  end

  it "renders Bootstrap 5 breadcrumb markup" do
    html = view.render_bootstrap_breadcrumbs

    expect(html).to have_tag("nav", :with => { "aria-label" => "breadcrumb" }) do
      with_tag("ol.breadcrumb li.breadcrumb-item a", :text => "Home", :with => { :href => "/" })
    end
  end

  it "marks the last crumb as the current page" do
    expect(view.render_bootstrap_breadcrumbs)
      .to have_tag("li.breadcrumb-item.active", :text => /Tasks/, :with => { "aria-current" => "page" })
  end

  it "sets the divider through Bootstrap's CSS variable" do
    nav = Nokogiri::HTML.fragment(view.render_bootstrap_breadcrumbs(">")).at_css("nav")

    expect(nav["style"]).to eq("--bs-breadcrumb-divider: '>';")
  end
end
