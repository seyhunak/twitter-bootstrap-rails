# Twitter Bootstrap for Rails 8, 7, 6, 5 and 4 Asset Pipeline

Bootstrap is a toolkit from Twitter designed to kickstart development of web apps and sites. It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.

twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails Asset Pipeline (Rails 8, Rails 7, Rails 6, Rails 5 and Rails 4.x versions are supported)

[![Gem Version](https://badge.fury.io/rb/twitter-bootstrap-rails.svg)](http://badge.fury.io/rb/twitter-bootstrap-rails)
[![Dependency Status](https://gemnasium.com/seyhunak/twitter-bootstrap-rails.svg?travis)](https://gemnasium.com/seyhunak/twitter-bootstrap-rails?travis)
[![Code Climate](https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails/badges/gpa.svg)](https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails?branch=master)
[![Coverage Status](https://coveralls.io/repos/seyhunak/twitter-bootstrap-rails/badge.svg?branch=master)](https://coveralls.io/repos/seyhunak/twitter-bootstrap-rails/badge.svg?branch=master)
[![GitHub stars](https://img.shields.io/github/stars/seyhunak/twitter-bootstrap-rails.svg)](https://github.com/seyhunak/twitter-bootstrap-rails/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/seyhunak/twitter-bootstrap-rails.svg)](https://github.com/seyhunak/twitter-bootstrap-rails/network)
[![GitHub issues](https://img.shields.io/github/issues/seyhunak/twitter-bootstrap-rails.svg)](https://github.com/seyhunak/twitter-bootstrap-rails/issues)

[![OpenCollective](https://opencollective.com/twitter-bootstrap-rails/backers/badge.svg)](#backers) 
[![OpenCollective](https://opencollective.com/twitter-bootstrap-rails/sponsors/badge.svg)](#sponsors)

## Screencasts
#### Installing twitter-bootstrap-rails, generators, usage and more

Screencasts provided by <a href="http://railscasts.com">RailsCasts</a> (Ryan Bates)

[Twitter Bootstrap Basics](http://railscasts.com/episodes/328-twitter-bootstrap-basics "Twitter Bootstrap Basics")
in this episode you will learn how to include Bootstrap into Rails application with the twitter-bootstrap-rails gem.

[More on Twitter Bootstrap](http://railscasts.com/episodes/329-more-on-twitter-bootstrap "More on Twitter Bootstrap")
in this episode continues on the Bootstrap project showing how to display flash messages, add form validations with SimpleForm, customise layout with variables, and switch to using Sass.
(Note: This episode is pro episode)

## Installing the Gem

The [Twitter Bootstrap Rails gem](http://rubygems.org/gems/twitter-bootstrap-rails) can provide the Bootstrap stylesheets in two ways.

The plain CSS way is how Bootstrap is provided on [the official website](http://twbs.github.io/bootstrap/).

The [Less](http://lesscss.org/) way provides more customisation options, like changing theme colors and provides useful Less mixins for your code, but requires the
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



