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
    self.stub!("uri_state").and_return(:inactive)
    self.stub!("root_url").and_return("/")
  end
  describe "nav_bar" do
    it "should return a basic bootstrap navbar" do
      nav_bar.gsub(/\s/, '').downcase.should eql(BASIC_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the fixed position to top" do
      nav_bar(:fixed => :top).gsub(/\s/, '').downcase.should eql(FIXED_TOP_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the static position to top" do
      nav_bar(:static => :top).gsub(/\s/, '').downcase.should eql(STATIC_TOP_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the fixed position to bottom" do
      nav_bar(:fixed => :bottom).gsub(/\s/, '').downcase.should eql(FIXED_BOTTOM_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should set the style to inverse" do
      nav_bar(:inverse => true).gsub(/\s/, '').downcase.should eql(INVERSE_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should add the brand name and link it to the home page" do
      nav_bar(:brand => "Ninety Ten").gsub(/\s/, '').downcase.should eql(NAVBAR_WITH_BRAND.gsub(/\s/, '').downcase)
    end

    it "should be able to set the brand link url" do
      nav_bar(:brand => "Ninety Ten", :brand_link => "http://www.ninetyten.com").gsub(/\s/, '').downcase.should eql(NAVBAR_WITH_BRAND_AND_LINK.gsub(/\s/, '').downcase)
    end

    it "should add the buttons etc for a responsive layout with no block passed" do
      nav_bar(:responsive => true).gsub(/\s/, '').downcase.should eql(RESPONSIVE_NAVBAR.gsub(/\s/, '').downcase)
    end

    it "should add the buttons etc for a responsive layout with block passed" do
      nav_bar(:responsive => true) do
        "<p>Passing a block</p>".html_safe
      end.gsub(/\s/, '').downcase.should eql(RESPONSIVE_NAVBAR_WITH_BLOCK.gsub(/\s/, '').downcase)
    end

    it "should render contained items" do
      nav_bar do
        menu_group do
          menu_item("Home", "/") + menu_item("Products", "/products")
        end
      end.gsub(/\s/, '').downcase.should eql(PLAIN_NAVBAR_WITH_ITEM.gsub(/\s/, '').downcase)
    end

    it "should still render the brand name even with other options turned on" do
      nav_bar(:brand => "Something") do
        menu_group do
          menu_item "Home", "/"
        end
      end.gsub(/\s/, '').downcase.should eql(BRANDED_NAVBAR_WITH_ITEM.gsub(/\s/, '').downcase)
    end
  end

  describe "menu_group" do
    it "should return a ul with the class 'nav'" do
      menu_group do
        menu_item("Home", "/") + menu_item("Products", "/products")
      end.should eql '<ul class="nav navbar-nav "><li><a href="/">Home</a></li><li><a href="/products">Products</a></li></ul>'
    end

    it "should return a ul with class .pull-left when passed the {:pull => :left} option" do
      menu_group(:pull => :left) do
        menu_item("Home", "/")
      end.should eql('<ul class="nav navbar-nav pull-left"><li><a href="/">Home</a></li></ul>')
    end
  end

  describe "menu_item" do
    it "should return a link within an li tag" do
      self.stub!("current_page?").and_return(false)
      menu_item("Home", "/").should eql('<li><a href="/">Home</a></li>')
    end
    it "should return the link with class 'active' if on current page" do
      self.stub!("uri_state").and_return(:active)
      menu_item("Home", "/").should eql('<li class="active"><a href="/">Home</a></li>')
    end
    it "should pass any other options through to the link_to method" do
      self.stub!("uri_state").and_return(:active)
      menu_item("Log out", "/users/sign_out", :class => "home_link", :method => :delete).should eql('<li class="active"><a class="home_link" data-method="delete" href="/users/sign_out" rel="nofollow">Log out</a></li>')
    end
    it "should pass a block but no name if a block is present" do
      self.stub!("current_page?").and_return(false)
      menu_item("/"){content_tag("i", "", :class => "icon-home") + " Home"}.should eql('<li><a href="/"><i class="icon-home"></i> Home</a></li>')
    end
    it "should work with just a block" do
      self.stub!("current_page?").and_return(false)
      menu_item{ content_tag("i", "", :class => "icon-home") + " Home" }.should eql('<li><a href="#"><i class="icon-home"></i> Home</a></li>')
    end
    it "should return the link with class 'active' if on current page with a block" do
      self.stub!("uri_state").and_return(:active)
      menu_item("/"){ content_tag("i", "", :class => "icon-home") + " Home" }.should eql('<li class="active"><a href="/"><i class="icon-home"></i> Home</a></li>')
    end
  end

  describe "drop_down" do
    it "should do render the proper drop down code" do
      drop_down "Products" do
        menu_item "Latest", "/"
      end.gsub(/\s/, '').downcase.should eql(DROPDOWN_MENU.gsub(/\s/, '').downcase)
    end
  end

  describe "drop_down_with_submenu" do
    it "should do render the proper drop down code" do
      drop_down_with_submenu "Products" do
        drop_down_submenu "Latest" do
          menu_item "Option1", "/"
        end
      end.gsub(/\s/, '').downcase.should eql(DROPDOWN_MENU_WITH_SUBMENU.gsub(/\s/, '').downcase)
    end
  end

  describe "menu_divider" do
    it "should render <li class='divider-vertical'></li>" do
      menu_divider.should eql '<li class="divider-vertical"></li>'
    end
  end

  describe "menu_text" do
    it "should render text within p tags with class 'navbar-text" do
      menu_text("Strapline!").should eql("<p class=\"navbar-text\">Strapline!</p>")
    end

    it "should be able to be pulled right or left" do
      menu_text("I am being pulled right", :pull => :right).should eql("<p class=\"pull-right navbar-text\">I am being pulled right</p>")
    end

    it "should be able to cope with arbitrary options being passed to the p tag" do
      menu_text("I am classy!", :class => "classy", :id => "classy_text").should eql("<p class=\"classy navbar-text\" id=\"classy_text\">I am classy!</p>")
    end

    it "should be able to cope with a block too" do
      menu_text do
        "I have been rendered programmatically!"
      end.should eql("<p class=\"navbar-text\">I have been rendered programmatically!</p>")
    end
  end

  describe "rendering forms ok" do
    it "should not escape anything unexpectedly" do
      nav_bar do
        form_tag "/", :method => 'get' do |f|
          f.text_field :search, "stub"
        end
      end.gsub(/\s/, '').downcase.should eql(PLAIN_NAVBAR_WITH_FORM.gsub(/\s/, '').downcase)
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
<li class="dropdown">
  <a class="dropdown-toggle"
        data-toggle="dropdown"
        href="#">
        Products
        <b class="caret"></b>
  </a>
  <ul class="dropdown-menu">
    <li><a href="/">Latest</a></li>
  </ul>
</li>
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
<nav class="navbar navbar-default" role="navigation">
  <div class="container">
    <form accept-charset="utf-8" action="/" method="get">
      <div style="margin:0;padding:0;display:inline">
        <input name="utf8" type="hidden" value="&#x2713;"/>
      </div>
      <input id="search_stub" name="search[stub]" type="text"/>
    </form>
  </div>
</nav>
HTML
