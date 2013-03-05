# Twitter Bootstrap for Rails 3.1 Asset Pipeline
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites. It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.

twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline (Rails 3.2 supported)

[![Gem Version](https://badge.fury.io/rb/twitter-bootstrap-rails.png)][gem]
[![Build Status](https://secure.travis-ci.org/seyhunak/twitter-bootstrap-rails.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/seyhunak/twitter-bootstrap-rails.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/seyhunak/twitter-bootstrap-rails/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/twitter-bootstrap-rails
[travis]: http://travis-ci.org/seyhunak/twitter-bootstrap-rails
[gemnasium]: https://gemnasium.com/seyhunak/twitter-bootstrap-rails
[codeclimate]: https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails
[coveralls]: https://coveralls.io/r/seyhunak/twitter-bootstrap-rails

## Screencasts
#### Installing twitter-bootstrap-rails, generators, usage and more
<img width="180" height="35" src="http://oi49.tinypic.com/s5wn05.jpg"></img>

Screencasts provided by <a href="http://railscasts.com">Railscasts</a> (Ryan Bates)

[Twitter Bootstrap Basics](http://railscasts.com/episodes/328-twitter-bootstrap-basics "Twitter Bootstrap Basics")
in this episode you will learn how to include Twitter Bootstrap into Rails application with the twitter-bootstrap-rails gem.

[More on Twitter Bootstrap](http://railscasts.com/episodes/329-more-on-twitter-bootstrap "More on Twitter Bootstrap")
in this episode continues on the Twitter Bootstrap project showing how to display flash messages, add form validations with SimpleForm, customize layout with variables, and switch to using Sass.
(Note: This episode is pro episode)


## Example Application
An example application is available at [toadkicker/teststrap](https://github.com/toadkicker/teststrap). You can view it running on heroku [here.](http://teststrap.herokuapp.com/) Contributions welcome.


## Installing the Gem

The [Twitter Bootstrap Rails gem](http://rubygems.org/gems/twitter-bootstrap-rails) can provide the Twitter Bootstrap stylesheets in two ways.

The plain CSS way is how Twitter Bootstrap is provided on [the official website](http://twitter.github.com/bootstrap/).

The [Less](http://lesscss.org/) way provides more customisation options, like changing theme colors, and provides useful Less mixins for your code, but requires the
Less gem and the Ruby Racer Javascript runtime (not available on Microsoft Windows).

### Installing the Less stylesheets

To use Less stylesheets, you'll need the [less-rails gem](http://rubygems.org/gems/less-rails), and one of [Javascript runtimes supported by CommonJS](https://github.com/cowboyd/commonjs.rb#supported-runtimes).

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

### Installing the CSS stylesheets

If you don't need to customize the stylesheets using Less, the only gem you need is the `twitter-bootstrap-rails` gem:

```ruby
gem "twitter-bootstrap-rails"
```

After running `bundle install`, run the generator:

    rails generate bootstrap:install static

## Generating layouts and views

You can run following generators to get started with Twitter Bootstrap quickly.


Layout (generates Twitter Bootstrap compatible layout) - (Haml and Slim supported)


Usage:


    rails g bootstrap:layout [LAYOUT_NAME] [*fixed or fluid]


Example of a fixed layout:


    rails g bootstrap:layout application fixed


Example of a responsive layout:


    rails g bootstrap:layout application fluid


Themed (generates Twitter Bootstrap compatible scaffold views.) - (Haml and Slim supported)


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
@import "twitter/bootstrap/reset.less";
@import "twitter/bootstrap/variables.less";
@import "twitter/bootstrap/mixins.less";
@import "twitter/bootstrap/scaffolding.less";
@import "twitter/bootstrap/grid.less";
@import "twitter/bootstrap/layouts.less";
@import "twitter/bootstrap/type.less";
@import "twitter/bootstrap/forms.less";
@import "twitter/bootstrap/wells.less";
@import "twitter/bootstrap/component-animations.less";
@import "twitter/bootstrap/buttons.less";
@import "twitter/bootstrap/close.less";
@import "twitter/bootstrap/navs.less";
@import "twitter/bootstrap/navbar.less";
@import "twitter/bootstrap/labels-badges.less";
@import "twitter/bootstrap/hero-unit.less";
@import "twitter/bootstrap/utilities.less";
@import "twitter/bootstrap/responsive";
```

If you'd like to alter Bootstrap's own variables, or define your LESS
styles inheriting Bootstrap's mixins, you can do so inside bootstrap_and_overrides.css.less:

```css
@linkColor: #ff0000;
```

### Icons

By default, this gem overrides standard Bootstraps's Glyphicons with Font Awesome (http://fortawesome.github.com/Font-Awesome/).
If you would like to restore the default Glyphicons, inside the _bootstrap_and_overrides.css.less_ remove the FontAwesome declaration and uncomment the line:

```css
// Font Awesome
// @import "fontawesome";
// Glyphicons
@import "twitter/bootstrap/sprites.less";
```

## Using Javascripts

You have to require Bootstrap JS (bootstrap.js) in your application.js

```js
//= require twitter/bootstrap

$(function(){
  /* Your javascripts goes here... */
});
```

If you want to customize what is loaded, your application.js would look something like this

```js
#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap/bootstrap-transition
#= require twitter/bootstrap/bootstrap-alert
#= require twitter/bootstrap/bootstrap-modal
#= require twitter/bootstrap/bootstrap-button
#= require twitter/bootstrap/bootstrap-collapse
```

...and so on for each bootstrap js component.

## Using Coffeescript (optionally)

Using Twitter Bootstrap with the CoffeeScript is easy.
twitter-bootstrap-rails generates a "bootstrap.js.coffee" file for you
to /app/assets/javascripts/ folder.

```coffee
jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
```

## Using Helpers

### Flash helper
Add flash helper `<%= bootstrap_flash %>` to your layout (built-in with layout generator)

### Breadcrumbs Helpers

Add breadcrumbs helper `<%= render_breadcrumbs %>` to your layout.

```ruby
class ApplicationController
  add_breadcrumb :index, :root_path
end
```

```ruby
class ExamplesController < ApplicationController
  add_breadcrumb :index, :examples_path

  def index
  end

  def show
    @example = Example.find params[:id]
    add_breadcrumb @example.name, example_path(@example)
    # add_breadcrumb :show, example_path(@example)
  end
end
```

Add I18n translations

```yml
en:
  breadcrumbs:
    application:
      index: "Index"
    examples:
      index: "Examples"
      show: "Example"
```
NOTE: If you are using Devise in your project, you must have a devise locale file
for handling flash messages, even if those messages are blank. See https://github.com/plataformatec/devise/wiki/I18n

## Changelog
<ul>
  <li>Version 0.0.5 deprecated</li>
  <li>Asset files updated to latest and removed version numbers</li>
  <li>Implemented Less::Rails Railtie to use with LESS</li>
  <li>Fixed railtie to only initialize Less when installed</li>
  <li>New branch for the static version of Bootstrap (w/o Less) - check static branch</li>
  <li>Added path to support heroku deploy</li>
  <li>Rake precompile issue fixed</li>
  <li>Updated asset files to 1.4.0</li>
  <li>Updated dependency less-rails (now requires 2.1.0)</li>
  <li>Added generators</li>
  <li>Fixed generators</li>
  <li>Fixed class name conflicts from (bootstrap.js.coffee)</li>
  <li>Fixed jquery-rails gem version dependency</li>
  <li>Updated asset files</li>
  <li>Added new generators (install, layout and themed)</li>
  <li>Compability to Rails 3.2</li>
  <li>Transitioning to 2.0</li>
  <li>Released gem v.2.0rc0</li>
  <li>Added Haml and Slim support</li>
  <li>Added Responsive layout support</li>
  <li>Fixes and release 2.0.0</li>
  <li>Updated to v2.0.1, versioned v2.0.1.0</li>
  <li>Released gem v.2.0.3</li>
  <li>Released gem v.2.0.4</li>
  <li>Released gem v.2.0.5</li>
  <li>Added SimpleForm support</li>
  <li>Added FontAwesome support</li>
  <li>Released gem v.2.0.6</li>
  <li>Released gem v.2.0.7</li>
  <li>Released gem v.2.0.8</li>
  <li>Released gem v.2.0.9 (Bootstrap 2.0.4 and FontAwesome 2.0 support)</li>
  <li>Released gem v.2.1.0 (JRuby support)</li>
  <li>Released gem v.2.1.1 (minor fixes)</li>
  <li>Flash block message helper added</li>
  <li>Released gem v.2.1.2 (minor fixes and updated to Twitter Bootstrap 2.1.0)</li>
  <li>Released gem v.2.1.3 (minor fixes and updated to Twitter Bootstrap 2.1.1)</li>
  <li>Released gem v.2.1.4 (minor fixes)</li>
  <li>Released gem v.2.1.5 (minor fixes, install generator detects javascript template engine, updated to Twitter Bootstrap 2.2.1)</li>
  <li>Released gem v.2.1.6 (minor fixes)</li>
  <li>Added static stylesheets support</li>
  <li>Released gem v.2.1.8 and updated to Twitter Bootstrap 2.2.2</li>
  <li>Released gem v.2.1.9</li>
  <li>Released gem v.2.2.0 (Font Awesome 3)</li>
  <li>Released gem v.2.2.1 (minor fixes and updates)</li>
  <li>Released gem v.2.2.2 (Bootstrap 2.3.0)</li>
  <li>Released gem v.2.2.3 (Minor fixes)</li>
  <li>Released gem v.2.2.4 (Minor fixes)</li>
  <li>Released gem v.2.2.5 (Bootstrap 2.3.1)</li>

</ul>


## Contributors & Patches & Forks
<ul>
  <li>Ben Lovell</li>
  <li>Daniel Morris</li>
  <li>Bradly Feeley</li>
  <li>Guilherme Moreira</li>
  <li>Alex Behar</li>
  <li>Brandon Keene</li>
  <li>Anthony Corcutt</li>
  <li>Colin Warren</li>
  <li>Giovanni Cappellotto</li>
  <li>Masakuni Kato</li>
  <li>Gudleik Rasch</li>
  <li>Thomas Volkmar Worm</li>
  <li>Thiago Almeida</li>
  <li>Sébastien Grosjean</li>
  <li>Nick DeSteffen</li>
  <li>Christian Joudrey</li>
  <li>Todd Baur</li>
  <li>Leonid Shevtsov</li>
</ul>


### Future
<ul>
  <li>Writing tests (not implemented yet)</li>
  <li>Markup Helpers (alert, tabs, pagination, breadcrumbs etc.)</li>
</ul>

## About Me
Lead/ Senior Developer - Programmer @useful (Usefulideas) Istanbul / Turkey

### Contact me
Seyhun Akyürek - seyhunak [at] gmail com

### Follow me
<a href="http://zerply.com/seyhunak">
<img width="110" height="40" src="http://zerply.com/img/welcomesteps/zerply_logo.png" />
</a>

(Twitter, Facebook, Linkedin, Google+, Github)

http://zerply.com/seyhunak

### Endorse me
<a href="http://coderwall.com/seyhunak">
<img src="http://api.coderwall.com/seyhunak/endorsecount.png" />
</a>

### Klout me
<img src="https://addons.opera.com/media/extensions/55/14355/1.0.1-rev1/icons/icon_64x64.png"></img>

Please +K my influence in Ruby on Rails on @klout

http://klout.com/#/seyhunak


### Want to donate?
<img src="https://www.paypalobjects.com/en_US/i/logo/PayPal_mark_50x34.gif"></img>

[Want to donate for my efforts?. Show your love](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=W8ZLWQBREFP4U
 "Donate")


## Thanks
Twitter Bootstrap and all twitter-bootstrap-rails contributors
http://twitter.github.com/bootstrap


## License
Copyright (c) 2012 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
