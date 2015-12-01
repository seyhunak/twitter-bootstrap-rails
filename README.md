# Twitter Bootstrap for Rails 4, 3.x Asset Pipeline
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites. It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.

twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails Asset Pipeline (Rails 4, 3.x versions are supported)

[![Gem Version](https://badge.fury.io/rb/twitter-bootstrap-rails.svg)](http://badge.fury.io/rb/twitter-bootstrap-rails)
[![Dependency Status](https://gemnasium.com/seyhunak/twitter-bootstrap-rails.svg?travis)](https://gemnasium.com/seyhunak/twitter-bootstrap-rails?travis)
[![Code Climate](https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails/badges/gpa.svg)](https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails?branch=master)
[![Coverage Status](https://coveralls.io/repos/seyhunak/twitter-bootstrap-rails/badge.png?branch=master)](https://coveralls.io/repos/seyhunak/twitter-bootstrap-rails/badge.png?branch=master)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/seyhunak/twitter-bootstrap-rails/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## Screencasts
#### Installing twitter-bootstrap-rails, generators, usage and more
<img width="180" height="35" src="http://oi49.tinypic.com/s5wn05.jpg"></img>

Screencasts provided by <a href="http://railscasts.com">Railscasts</a> (Ryan Bates)

[Twitter Bootstrap Basics](http://railscasts.com/episodes/328-twitter-bootstrap-basics "Twitter Bootstrap Basics")
in this episode you will learn how to include Bootstrap into Rails application with the twitter-bootstrap-rails gem.

[More on Twitter Bootstrap](http://railscasts.com/episodes/329-more-on-twitter-bootstrap "More on Twitter Bootstrap")
in this episode continues on the Bootstrap project showing how to display flash messages, add form validations with SimpleForm, customize layout with variables, and switch to using Sass.
(Note: This episode is pro episode)

## Installing the Gem

The [Twitter Bootstrap Rails gem](http://rubygems.org/gems/twitter-bootstrap-rails) can provide the Bootstrap stylesheets in two ways.

The plain CSS way is how Bootstrap is provided on [the official website](http://twbs.github.io/bootstrap/).

The [Less](http://lesscss.org/) way provides more customization options, like changing theme colors, and provides useful Less mixins for your code, but requires the
Less gem and the Ruby Racer Javascript runtime (not available on Microsoft Windows).

### Installing the Less stylesheets

To use Less stylesheets, you'll need the [less-rails gem](http://rubygems.org/gems/less-rails), and one of [JavaScript runtimes supported by CommonJS](https://github.com/cowboyd/commonjs.rb#supported-runtimes).

Include these lines in the Gemfile to install the gems from [RubyGems.org](http://rubygems.org):

```ruby
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
```

or you can install from latest build;

```ruby
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
```

Then run `bundle install` from the command line:

    bundle install

Then run the bootstrap generator to add Bootstrap includes into your assets:

    rails generate bootstrap:install less

If you need to skip coffeescript replacement into app generators, use:

    rails generate bootstrap:install --no-coffeescript

### Installing the CSS stylesheets

If you don't need to customize the stylesheets using Less, the only gem you need is the `twitter-bootstrap-rails` gem:

```ruby
gem "twitter-bootstrap-rails"
```

After running `bundle install`, run the generator:

    rails generate bootstrap:install static

## Generating layouts and views

You can run following generators to get started with Bootstrap quickly.


Layout (generates Bootstrap compatible layout) - (Haml and Slim supported)


Usage:


    rails g bootstrap:layout [LAYOUT_NAME]


Themed (generates Bootstrap compatible scaffold views.) - (Haml and Slim supported)


Usage:


    rails g bootstrap:themed [RESOURCE_NAME]


Example:


    rails g scaffold Post title:string description:text
    rake db:migrate
    rails g bootstrap:themed Posts

Notice the plural usage of the resource to generate bootstrap:themed.

## Using with Less

Bootstrap was built with Preboot, an open-source pack of mixins and variables to be used in conjunction with Less, a CSS preprocessor for faster and easier web development.

## Using stylesheets with Less

You have to require Bootstrap LESS (bootstrap_and_overrides.css.less) in your application.css

```css
/*
 *= require bootstrap_and_overrides
 */

/* Your stylesheets goes here... */
```

To use individual components from bootstrap, your bootstrap_and_overrides.less could look like this:

```css
// Core variables and mixins
@import "twitter/bootstrap/variables.less";
@import "twitter/bootstrap/mixins.less";

// Reset and dependencies
@import "twitter/bootstrap/normalize.less";
@import "twitter/bootstrap/print.less";
//@import "twitter/bootstrap/glyphicons.less"; // Excludes glyphicons

// Core CSS
@import "twitter/bootstrap/scaffolding.less";
@import "twitter/bootstrap/type.less";
@import "twitter/bootstrap/code.less";
@import "twitter/bootstrap/grid.less";
@import "twitter/bootstrap/tables.less";
@import "twitter/bootstrap/forms.less";
@import "twitter/bootstrap/buttons.less";

// Components
@import "twitter/bootstrap/component-animations.less";
@import "twitter/bootstrap/dropdowns.less";
@import "twitter/bootstrap/button-groups.less";
@import "twitter/bootstrap/input-groups.less";
@import "twitter/bootstrap/navs.less";
@import "twitter/bootstrap/navbar.less";
@import "twitter/bootstrap/breadcrumbs.less";
@import "twitter/bootstrap/pagination.less";
@import "twitter/bootstrap/pager.less";
@import "twitter/bootstrap/labels.less";
@import "twitter/bootstrap/badges.less";
@import "twitter/bootstrap/jumbotron.less";
@import "twitter/bootstrap/thumbnails.less";
@import "twitter/bootstrap/alerts.less";
@import "twitter/bootstrap/progress-bars.less";
@import "twitter/bootstrap/media.less";
@import "twitter/bootstrap/list-group.less";
@import "twitter/bootstrap/panels.less";
@import "twitter/bootstrap/responsive-embed.less";
@import "twitter/bootstrap/wells.less";
@import "twitter/bootstrap/close.less";

// Components w/ JavaScript
@import "twitter/bootstrap/modals.less";
@import "twitter/bootstrap/tooltip.less";
@import "twitter/bootstrap/popovers.less";
@import "twitter/bootstrap/carousel.less";

// Utility classes
@import "twitter/bootstrap/utilities.less";
@import "twitter/bootstrap/responsive-utilities.less";
```

If you'd like to alter Bootstrap's own variables, or define your LESS
styles inheriting Bootstrap's mixins, you can do so inside bootstrap_and_overrides.css.less:


```css
@link-color: #ff0000;
```

### SASS

If you are using SASS to compile your application.css (e.g. your manifest file is application.css.sass or application.css.scss) you may get this:

```
Invalid CSS after "*": expected "{", was "= require twitt..."
(in app/assets/stylesheets/application.css)
(sass)
```

If this is the case, you **must** use @import instead of `*=` in your manifest file, or don't compile your manifest with SASS.

### Icons

By default, this gem overrides standard Bootstraps's Glyphicons with Font Awesome (http://fortawesome.github.com/Font-Awesome/).

This should appear inside _bootstrap_and_overrides *(based on you twitter-bootstrap-rails version)*

**From 2.2.7**

```css
// Font Awesome
@fontAwesomeEotPath: asset-url("fontawesome-webfont.eot");
@fontAwesomeEotPath_iefix: asset-url("fontawesome-webfont.eot?#iefix");
@fontAwesomeWoffPath: asset-url("fontawesome-webfont.woff");
@fontAwesomeTtfPath: asset-url("fontawesome-webfont.ttf");
@fontAwesomeSvgPath: asset-url("fontawesome-webfont.svg#fontawesomeregular");
@import "fontawesome/font-awesome";
```

**Before 2.2.7**

```css
// Font Awesome
@fontAwesomeEotPath: "/assets/fontawesome-webfont.eot";
@fontAwesomeEotPath_iefix: "/assets/fontawesome-webfont.eot?#iefix";
@fontAwesomeWoffPath: "/assets/fontawesome-webfont.woff";
@fontAwesomeTtfPath: "/assets/fontawesome-webfont.ttf";
@fontAwesomeSvgPath: "/assets/fontawesome-webfont.svg#fontawesomeregular";
@import "fontawesome";
```

If you would like to restore the default Glyphicons, inside the _bootstrap_and_overrides.css.less_ remove the FontAwesome declaration and uncomment the line:

```less
// Font Awesome
// @fontAwesomeEotPath: asset-url("fontawesome-webfont.eot");
// @fontAwesomeEotPath_iefix: asset-url("fontawesome-webfont.eot?#iefix");
// @fontAwesomeWoffPath: asset-url("fontawesome-webfont.woff");
// @fontAwesomeTtfPath: asset-url("fontawesome-webfont.ttf");
// @fontAwesomeSvgPath: asset-url("fontawesome-webfont.svg#fontawesomeregular");
// @import "fontawesome/font-awesome";

// Glyphicons
@import "twitter/bootstrap/glyphicons.less";
```

## Using JavaScript

Require Bootstrap JS (bootstrap.js) in your application.js

```js
//= require twitter/bootstrap

$(function(){
  /* Your JavaScript goes here... */
});
```

If you want to customize what is loaded, your application.js would look something like this

```js
#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap/transition
#= require twitter/bootstrap/alert
#= require twitter/bootstrap/modal
#= require twitter/bootstrap/button
#= require twitter/bootstrap/collapse
```

...and so on for each bootstrap js component.

## Using CoffeeScript (optionally)

Using Bootstrap with the CoffeeScript is easy.
twitter-bootstrap-rails generates a "bootstrap.js.coffee" file for you
to /app/assets/javascripts/ folder.

```coffee
jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
```

## Using Helpers

### Modal Helper
You can create modals easily using the following example. The header, body, and footer all accept content_tag or plain html.
The href of the button to launch the modal must match the id of the modal dialog. It also accepts a block for the header, body, and footer. If you are getting a complaint about the modal_helper unable to merge a hash it is due to this.

````
<%= content_tag :a, "Modal", href: "#modal", class: 'btn', data: {toggle: 'modal'} %>

<%= modal_dialog id: "modal",
         header: { show_close: true, dismiss: 'modal', title: 'Modal header' },
         body:   { content: 'This is the body' },
         footer: { content: content_tag(:button, 'Save', class: 'btn') } %>

````

### Navbar Helper
It should let you write things like:

````

<%= nav_bar fixed: :top, brand: "Fashionable Clicheizr 2.0", responsive: true do %>
    <%= menu_group do %>
        <%= menu_item "Home", root_path %>
        <%= menu_divider %>
        <%= drop_down "Products" do %>
            <%= menu_item "Things you can't afford", expensive_products_path %>
            <%= menu_item "Things that won't suit you anyway", harem_pants_path %>
            <%= menu_item "Things you're not even cool enough to buy anyway", hipster_products_path %>
            <% if current_user.lives_in_hackney? %>
                <%= menu_item "Bikes", fixed_wheel_bikes_path %>
            <% end %>
        <% end %>
        <%= menu_item "About Us", about_us_path %>
        <%= menu_item "Contact", contact_path %>
    <% end %>
    <%= menu_group pull: :right do %>
        <% if current_user %>
            <%= menu_item "Log Out", log_out_path %>
        <% else %>
            <%= form_for @user, url: session_path(:user), html => {class: "navbar-form pull-right"} do |f| -%>
              <p><%= f.text_field :email %></p>
              <p><%= f.password_field :password %></p>
              <p><%= f.submit "Sign in" %></p>
            <% end -%>
        <% end %>
    <% end %>
<% end %>


````

### Navbar scaffolding

In your view file (most likely application.html.erb) to get a basic navbar set up you need to do this:

````
<%= nav_bar %>
````

Which will render:

    <div class="navbar">
      <div class="container">
      </div>
    </div>


### Fixed navbar

If you want the navbar to stick to the top of the screen, pass in the option like this:

````
<%= nav_bar fixed: :top  %>
````

To render:

    <div class="navbar navbar-fixed-top">
      <div class="container">
      </div>
    </div>

### Static navbar

If you want a full-width navbar that scrolls away with the page, pass in the option like this:

````
<%= nav_bar static: :top  %>
````

To render:

    <div class="navbar navbar-static-top">
      <div class="container">
      </div>
    </div>


### Brand name

Add the name of your site on the left hand edge of the navbar. By default, it will link to root_url. Passing a brand_link option will set the url to whatever you want.

````
<%= nav_bar brand: "We're sooo web 2.0alizr", brand_link: account_dashboard_path  %>
````

Which will render:

    <div class="navbar">
      <div class="container">
          <a class="navbar-brand" href="/accounts/dashboard">
            We're sooo web 2.0alizr
          </a>
      </div>
    </div>


### Optional responsive variation

If you want the responsive version of the navbar to work (One that shrinks down on mobile devices etc.), you need to pass this option:

````
<%= nav_bar responsive: true %>
````
Which renders the html quite differently:


    <div class="navbar">
      <div class="container">
        <!-- .navbar-toggle is used as the toggle for collapsed navbar content -->
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <!-- Everything in here gets hidden at 940px or less -->
        <div class="navbar-collapse collapse">
          <!-- menu items gets rendered here instead -->
        </div>
      </div>
    </div>


### Nav links

This is the 'meat' of the code where you define your menu items.

You can group menu items in theoretical boxes which you can apply logic to - e.g. show different collections for logged in users/logged out users, or simply right align a group.

The active menu item will be inferred from the link for now.

The important methods here are menu_group and menu_item.

menu_group only takes one argument - :pull - this moves the group left or right when passed :left or :right.

menu_item generates a link wrapped in an li tag. It takes two arguments and an options hash. The first argument is the name (the text that will appear in the menu), and the path (which defaults to "#" if left blank). The rest of the options are passed straight through to the link_to helper, so that you can add classes, ids, methods or data tags etc.

````

<%= nav_bar fixed: :top, brand: "Ninety Ten" do %>
    <%= menu_group do %>
        <%= menu_item "Home", root_path %>
        <%= menu_item "About Us", about_us_path %>
        <%= menu_item "Contact", contact_path %>
    <% end %>
    <% if current_user %>
        <%= menu_item "Log Out", log_out_path %>
    <% else %>
        <%= menu_group pull: :right do %>
            <%= menu_item "Sign Up", registration_path %>
            <%= form_for @user, url: session_path(:user) do |f| -%>
              <p><%= f.text_field :email %></p>
              <p><%= f.password_field :password %></p>
              <p><%= f.submit "Sign in" %></p>
            <% end -%>
        <% end %>
    <% end %>
<% end %>

````

### Dropdown menus

For multi-level list options, where it makes logical sense to group menu items, or simply to save space if you have a lot of pages, you can group menu items into drop down lists like this:

````
<%= nav_bar do %>
    <%= menu_item "Home", root_path %>

    <%= drop_down "Products" do %>
        <%= menu_item "Latest", latest_products_path %>
        <%= menu_item "Top Sellers", popular_products_path %>
        <%= drop_down_divider %>
        <%= menu_item "Discount Items", discounted_products_path %>
    <% end %>

    <%= menu_item "About Us", about_us_path %>
    <%= menu_item "Contact", contact_path %>
<% end %>

````

### Dividers

Dividers are just vertical bars that visually separate logically disparate groups of menu items

````

<%= nav_bar fixed: :bottom do %>
    <%= menu_item "Home", root_path %>
    <%= menu_item "About Us", about_us_path %>
    <%= menu_item "Contact", contact_path %>

    <%= menu_divider %>

    <%= menu_item "Edit Profile", edit_user_path(current_user) %>
    <%= menu_item "Account Settings", edit_user_account_path(current_user, @account) %>
    <%= menu_item "Log Out", log_out_path %>
<% end %>

````

### Forms in navbar

At the moment - this is just a how to...

You need to add this class to the form itself (Different form builders do this in different ways - please check out the relevant docs)

````css
.navbar-form
````
To pull the form left or right, add either of these classes:
````css
.pull-left
.pull-right
````

If you want the Bootstrap search box (I think it just rounds the corners), use:
````css
.navbar-search
````
Instead of:
````css
.navbar-form
````

To change the size of the form fields, use .span2 (or however many span widths you want) to the input itself.

### Component alignment

You can shift things to the left or the right across the nav bar. It's easiest to do this on grouped menu items:

````
<%= nav_bar fixed: :bottom do %>
    <% menu_group do %>
        <%= menu_item "Home", root_path %>
        <%= menu_item "About Us", about_us_path %>
        <%= menu_item "Contact", contact_path %>
    <% end %>
    <% menu_group pull: :right do %>
        <%= menu_item "Edit Profile", edit_user_path(current_user) %>
        <%= menu_item "Account Settings", edit_user_account_path(current_user, @account) %>
        <%= menu_item "Log Out", log_out_path %>
    <% end %>
<% end %>

````

### Text in the navbar

If you want to put regular plain text in the navbar anywhere, you do it like this:

````
<%= nav_bar brand: "Apple" do %>
    <%= menu_text "We make shiny things" %>
    <%= menu_item "Home", root_path %>
    <%= menu_item "About Us", about_us_path %>
<% end %>

````
It also takes the :pull option to drag it to the left or right.


### Flash helper

Add flash helper `<%= bootstrap_flash %>` to your layout (built-in with layout generator).
You can pass the attributes you want to add to the main div returned: `<%= bootstrap_flash(class: "extra-class", id: "your-id") %>`


### Breadcrumbs Helpers

*Notice* If your application is using [breadcrumbs-on-rails](https://github.com/weppos/breadcrumbs_on_rails) you will have a namespace collision with the add_breadcrumb method. For this reason if breadcrumbs-on-rails is detected in `Gemfile` gem methods will be accessible using `boostrap` prefix, i.e. `render_bootstrap_breadcrumbs` and `add_bootstrap_breadcrumb`

Usually you do not need to use these breadcrumb gems since this gem provides the same functionality out of the box without the additional dependency.

However if there are some `breadcrumbs-on-rails` features you need to keep you can still use them and use this gem with the prefixes explained above.

Add breadcrumbs helper `<%= render_breadcrumbs %>` to your layout.
You can also specify a divider for it like this: `<%= render_breadcrumbs('>') %>` (default divider is `/`).
If you do not need dividers at all you can use `nil`: `<%= render_breadcrumbs(nil) %>`.

Full example:
```ruby

render_breadcrumbs(" / ", { class: '', item_class: '', divider_class: '', active_class: 'active' })

```

```ruby
class ApplicationController
  add_breadcrumb :root # 'root_path' will be used as url
end
```

```ruby
class ExamplesController < ApplicationController
  add_breadcrumb :index, :examples_path

  def edit
    @example = Example.find params[:id]
    add_breadcrumb @example # @example.to_s as name, example_path(@example) as url
    add_breadcrumb :edit, edit_example_path(@example)
  end
end
```
All symbolic names translated with I18n. See [I18n Internationalization Support](#i18n-internationalization-support)
section.

### Element utility helpers

Badge:
```erb
<%= badge(12, :warning) %> <span class="badge badge-warning">12</span>
```

Label:
```erb
<%= tag_label('Gut!', :success) %> <span class="label label-success">Gut!</span>
```

Glyph:
```erb
<%= glyph(:pencil) %> <i class="icon-pencil"></i>

<%= glyph(:pencil, {tag: :span}) %> <span class="icon-pencil"></span>
```

### I18n Internationalization Support
The installer creates an English translation file for you and copies it to config/locales/en.bootstrap.yml


NOTE: If you are using Devise in your project, you must have a devise locale file
for handling flash messages, even if those messages are blank. See https://github.com/plataformatec/devise/wiki/I18n

## Changelog
Please see CHANGELOG.md for more details

## Contributors & Patches & Forks
Please see CONTRIBUTERS.md for contributors list


## About Me
CTO / Senior Developer / Programmer
@useful (Usefulideas) Istanbul / Turkey


### Contact me
Seyhun Akyürek - seyhunak [at] gmail com


## Thanks
Bootstrap and all twitter-bootstrap-rails contributors
http://twbs.github.io/bootstrap


## License
Copyright (c) 2014 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
