# encoding: utf-8
#Credit for this goes to https://github.com/julescopeland/Rails-Bootstrap-Navbar
require 'spec_helper'
require 'action_view'
require 'active_support'
require_relative '../../../app/helpers/navbar_helper'

include ActionView::Helpers
include ActionView::Context
include NavbarHelper

describe NavbarHelper, :type => :helper do
  before do
    allow(self).to receive(:uri_state) { :inactive }
    allow(self).to receive(:root_url) { '/' }
  end
  describe "nav_bar" do
    it "should return a basic bootstrap navbar" do
      expect(nav_bar.gsub(/\s/, '').downcase)
        .to eql(BASIC_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the fixed position to top" do
      expect(nav_bar(:fixed => :top).gsub(/\s/, '').downcase)
        .to eql(FIXED_TOP_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the static position to top" do
      expect(nav_bar(:static => :top).gsub(/\s/, '').downcase)
        .to eql(STATIC_TOP_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the fixed position to bottom" do
      expect(nav_bar(:fixed => :bottom).gsub(/\s/, '').downcase)
        .to eql(FIXED_BOTTOM_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the style to inverse" do
      expect(nav_bar(:inverse => true).gsub(/\s/, '').downcase)
        .to eql(INVERSE_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should add the brand name and link it to the home page" do
      expect(nav_bar(:brand => "Ninety Ten").gsub(/\s/, '').downcase)
        .to eql(NAVBAR_WITH_BRAND.gsub(/\s/, '').downcase)
    end

    it "should be able to set the brand link url" do
      expect(nav_bar(:brand => "Ninety Ten", :brand_link => "http://www.ninetyten.com").gsub(/\s/, '').downcase)
        .to eql(NAVBAR_WITH_BRAND_AND_LINK.gsub(/\s/, '').downcase)
    end

    it "should add the buttons etc for a responsive layout with no block passed" do
      expect(nav_bar(:responsive => true).gsub(/\s/, '').downcase).to eql(RESPONSIVE_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should add the buttons etc for a responsive layout with block passed" do
      ele = nav_bar(:responsive => true) do
        "<p>Passing a block</p>".html_safe
      end
      expect(ele.gsub(/\s/, '').downcase).to eql(RESPONSIVE_NAVBAR_WITH_BLOCK.gsub(/\s/, '').downcase)
    end

    it "should render contained items" do
      ele = nav_bar do
        menu_group do
          menu_item("Home", "/") + menu_item("Products", "/products")
        end
      end
      expect(ele.gsub(/\s/, '').downcase).to eql(PLAIN_NAVBAR_WITH_ITEM.gsub(/\s/, '').downcase)
    end

    it "should still render the brand name even with other options turned on" do
      ele = nav_bar(:brand => "Something") do
        menu_group do
          menu_item "Home", "/"
        end
      end
      expect(ele.gsub(/\s/, '').downcase).to eql(BRANDED_NAVBAR_WITH_ITEM.gsub(/\s/, '').downcase)
    end
  end

  describe "menu_group" do
    it "should return a ul with the class 'nav'" do
      element = menu_group do
        menu_item("Home", "/") + menu_item("Products", "/products")
      end

      expect(element).to have_tag(:ul, with: {class: "nav navbar-nav"}) {
        with_tag(:li) {
          with_tag(:a, text: "Home", with: {href: "/"})
        }
        with_tag(:li) {
          with_tag(:a, text: "Products", with: {href: "/products"})
        }
      }
    end

    it "should return a ul with class .navbar-left when passed the {pull: :left} option" do
      element = menu_group(pull: :left) do
        menu_item("Home", "/")
      end

      expect(element).to have_tag(:ul, with: {class: "nav navbar-nav navbar-left"}) {
        with_tag(:li) {
          with_tag(:a, text: "Home", with: {href: "/"})
        }
      }
    end
  end

  describe "menu_item" do
    it "should return a link within an li tag" do
      allow(self).to receive(:current_page?) { false }

      element = menu_item("Home", "/")
      expect(element).to have_tag(:li) {
        with_tag(:a, text: "Home", with: { href: "/" })
      }
    end

    it "should return the link with class 'active' if on current page" do
      allow(self).to receive(:uri_state) { :active }

      element = menu_item("Home", "/")
      expect(element).to have_tag(:li, with: {class: "active"}) {
        with_tag(:a, text: "Home", with: { href: "/" })
      }
    end

    it "should pass any other options through to the link_to method" do
      allow(self).to receive_message_chain("uri_state").and_return(:active)

      element = menu_item("Log out", "/users/sign_out", class: "home_link", method: :delete)
      expect(element).to have_tag(:li, with: {class: "active"}) {
        with_tag(:a, text: "Log out", with: {
          href: "/users/sign_out",
          class: "home_link",
          rel: "nofollow",
          "data-method" => "delete"
        })
      }
    end

    it "should pass a block but no name if a block is present" do
      allow(self).to receive(:current_page?) { false }

      element = menu_item("/"){ content_tag("i", "", :class => "icon-home") + " Home" }
      expect(element).to have_tag(:li) {
        with_tag(:i, with: { class: "icon-home"})
        with_tag(:a, text: " Home", with: { href: "/"})
      }
    end

    it "should work with just a block" do
      allow(self).to receive(:current_page?) { false }

      element = menu_item{ content_tag("i", "", :class => "icon-home") + " Home" }
      expect(element).to have_tag(:li) {
        with_tag(:i, with: { class: "icon-home"})
        with_tag(:a, text: " Home", with: { href: "#"})
      }
    end

    it "should return the link with class 'active' if on current page with a block" do
      allow(self).to receive(:uri_state) { :active }

      element = menu_item("/"){ content_tag("i", "", :class => "icon-home") + " Home" }
      expect(element).to have_tag(:li, with: {class: "active"}) {
        with_tag(:i, with: { class: "icon-home"})
        with_tag(:a, text: " Home", with: { href: "/"})
      }
    end
  end

  describe "drop_down" do
    it "should do render the proper drop down code" do
      ele = drop_down "Products" do
        menu_item "Latest", "/"
      end
      expect(ele).to have_tag(:li, with: {class: 'dropdown'})
      expect(ele).to have_tag(:a, with: {class: 'dropdown-toggle'})
    end
  end

  describe "drop_down_with_submenu" do
    it "should do render the proper drop down code" do
      ele = drop_down_with_submenu "Products" do
          drop_down_submenu "Latest" do
            menu_item "Option1", "/"
          end
        end
      expect(ele).to have_tag(:li, with: {class: 'dropdown'})
      expect(ele).to have_tag(:a, with: {class: 'dropdown-toggle'})
      expect(ele).to have_tag(:ul, with: {class: 'dropdown-menu'})
    end
  end

  describe "menu_divider" do
    it "should render <li class='divider-vertical'></li>" do
      expect(menu_divider).to match '<li class="divider-vertical"></li>'
    end
  end

  describe "menu_text" do
    it "should render text within p tags with class 'navbar-text" do
      expect(menu_text("Strapline!")).to match("<p class=\"navbar-text\">Strapline!</p>")
    end

    it "should be able to be pulled right or left" do
      expect(menu_text("I am being pulled right", :pull => :right)).to match("<p class=\"pull-right navbar-text\">I am being pulled right</p>")
    end

    it "should be able to cope with arbitrary options being passed to the p tag" do
      expect(menu_text("I am classy!", :class => "classy", :id => "classy_text")).to match("<p class=\"classy navbar-text\" id=\"classy_text\">I am classy!</p>")
    end

    it "should be able to cope with a block too" do
      ele = menu_text("I have been rendered programmatically!")
      expect(ele).to have_tag(:p, with: {class: "navbar-text"})
      expect(ele).to match "I have been rendered programmatically!"
    end
  end

  describe "rendering forms ok" do
    it "should not escape anything unexpectedly" do
      expect(
        nav_bar do
          form_tag "/", :method => 'get' do |f|
            f.text_field :search, "stub"
          end
        end
        ).to have_tag(:form)
    end
  end

  describe "default navbar" do
    it "renders a navbar" do
      expect(nav_bar { 'foo' }).to have_tag(:nav, with: { class: 'navbar navbar-default', role: 'navigation' }, text: /foo/)
    end
  end

end

# HTML output

BASIC_NAVBAR = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
  </div>
</nav>
HTML

FIXED_TOP_NAVBAR = <<-HTML
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <div class="container">
  </div>
</nav>
HTML

STATIC_TOP_NAVBAR = <<-HTML
<nav class="navbar navbar-default navbar-static-top" role="navigation">
  <div class="container">
  </div>
</nav>
HTML

FIXED_BOTTOM_NAVBAR = <<-HTML
<nav class="navbar navbar-default navbar-fixed-bottom" role="navigation">
  <div class="container">
  </div>
</nav>
HTML

INVERSE_NAVBAR = <<-HTML
<nav class="navbar navbar-default navbar-inverse" role="navigation">
  <div class="container">
  </div>
</nav>
HTML

NAVBAR_WITH_BRAND = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <a class="navbar-brand" href="/">
      Ninety Ten
    </a>
  </div>
</nav>
HTML

NAVBAR_WITH_BRAND_AND_LINK = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <a class="navbar-brand" href="http://www.ninetyten.com">
      Ninety Ten
    </a>
  </div>
</nav>
HTML

RESPONSIVE_NAVBAR = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle Navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>
    <div class="navbar-collapse collapse">
    </div>
  </div>
</nav>
HTML

RESPONSIVE_NAVBAR_WITH_BLOCK = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle Navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>
    <div class="navbar-collapse collapse">
              <p>Passing a block</p>
    </div>
  </div>
</nav>
HTML

PLAIN_NAVBAR_WITH_ITEM = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <ul class="nav navbar-nav">
      <li>
        <a href="/">Home</a>
      </li>
      <li>
        <a href="/products">Products</a>
      </li>
    </ul>
  </div>
</nav>
HTML

BRANDED_NAVBAR_WITH_ITEM = <<-HTML
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <a class="navbar-brand" href="/">
      Something
    </a>
    <ul class="nav navbar-nav">
      <li>
        <a href="/">Home</a>
      </li>
    </ul>
  </div>
</nav>
HTML

DROPDOWN_MENU = <<-HTML
<li class="dropdown"> <a class="dropdown-toggle"data-toggle="dropdown"href="#"> Products <b class="caret"></b> </a> <ul class="dropdown-menu"> <li><a href="/">Latest</a></li> </ul> </li>
HTML

DROPDOWN_MENU_WITH_SUBMENU = <<-HTML
<li class="dropdown">
  <a class="dropdown-toggle" data-toggle="dropdown" href="#">Products <b class="caret"></b></a>
  <ul class="dropdown-menu">
    <li class="dropdown-submenu">
      <a href="">Latest</a>
      <ul class="dropdown-menu">
        <li><a href="/">Option1</a></li>
      </ul>
    </li>
  </ul>
</li>
HTML

PLAIN_NAVBAR_WITH_FORM = <<-HTML
<nav class=\"navbar navbar-default\"role=\"navigation\">
  <div class=\"container\">
    <form accept-charset=\"utf-8\" action=\"/\" method=\"get\">
      <div style=\"display:none\">
        <input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\"/>
      </div>
      <input id=\"search_stub\" name=\"search[stub]\" type=\"text\"/>
    </form>
  </div>
</nav>
HTML
