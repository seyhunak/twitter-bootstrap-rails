# Twitter Bootstrap for Rails 3
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites.
It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.
twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3 projects

## Rails 3.1
Include Bootstrap in Gemfile, 
    gem 'twitter-bootstrap-rails'
    or
    gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git' 
    and run bundle install.

Add necessary stylesheet file to app/assets/stylesheets/application.css

    /* ...
	*= require bootstrap-1.2.0
	or
	*= require bootstrap-1.2.0.min
     * ...
    */

Not tested on Rails 3

## Authors
Seyhun Akyürek
Daniel Morris
Bradly Feeley

## Thanks
Thanks Twitter for Bootstrap
http://twitter.github.com/bootstrap