# Twitter Bootstrap for Rails 3.1 Asset Pipeline
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites. It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.

twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline (Rails 3.2 supported)

[![Build Status](https://secure.travis-ci.org/seyhunak/twitter-bootstrap-rails.png)](http://travis-ci.org/seyhunak/twitter-bootstrap-rails)
[![Dependency Status](https://gemnasium.com/seyhunak/twitter-bootstrap-rails.png)](https://gemnasium.com/seyhunak/twitter-bootstrap-rails)

## Installing Gem

Include Bootstrap in Gemfile;

    gem "twitter-bootstrap-rails"

or you can install from latest build;

    gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'

You can run bundle from command line

    bundle install


## Installing to App (using Generators)

You can run following generators to get started with Twitter Bootstrap quickly.


Install (requires directives to Asset pipeline.)


Usage:


    rails g bootstrap:install


Layout (generates Twitter Bootstrap compatible layout) - (Haml and Slim supported)


Usage:


    rails g bootstrap:layout [LAYOUT_NAME] [*ﬁxed or ﬂuid]


Example:


    rails g bootstrap:layout application fixed


Themed (generates Twitter Bootstrap compatible scaffold views.) - (Haml and Slim supported)


Usage:


    rails g bootstrap:themed [RESOURCE_NAME]


Example:


    rails g scaffold post title:string description:text
    rake db:migrate
    rails g bootstrap:themed posts



## Using with Less

Bootstrap was built with Preboot, an open-source pack of mixins and variables to be used in conjunction with Less, a CSS preprocessor for faster and easier web development.

## Using stylesheets with Less

You have to require Bootstrap LESS (bootstrap_and_overrides.css.less) in your application.css

    /*
     *= require bootstrap_and_overrides
     */

    /* Your stylesheets goes here... */


If you'd like to alter Bootstrap's own variables, or define your LESS
styles inheriting Bootstrap's mixins, you can do so inside bootstrap_and_overrides.css.less:

    @linkColor: #ff0000;



## Using Javascripts

You have to require Bootstrap JS (bootstrap.js) in your application.js

    //= require twitter/bootstrap

    $(document).ready(function(){
      /* Your javascripts goes here... */
    });


## Using Coffeescript (optionally)

Using Twitter Bootstrap with the CoffeeScript is easy.
twitter-bootstrap-rails generates a "bootstrap.js.coffee" file for you
to /app/assets/javascripts/ folder.

    jQuery ->
      $("a[rel=popover]").popover()
      $(".tooltip").tooltip()
      $("a[rel=tooltip]").tooltip()


## Using Static CSS, JS (w/o Less)

twitter-bootstrap-rails has seperate branch (w/o Less) that just serves latest static CSS, JS files.

    You can install from latest build (from branch);

    gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git", :branch => "static"


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
</ul>


## Contributors & Patches & Forks
<ul>
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
</ul>


## Future
<ul>
  <li>Writing tests (not implemented yet)</li>
  <li>Markup Helpers (alert, tabs, pagination, breadcrumbs etc.)</li>
</ul>

## Credits
Seyhun Akyürek - seyhunak [at] gmail com

[Visit My Blog](http://www.seyhunakyurek.com/ "Visit My Blog")

[Add Me On Twitter](http://twitter.com/seyhunak "Add Me On Twitter")
[Add Me On Linkedin](http://tr.linkedin.com/in/seyhunak "Add Me On Linkedin")
[Add Me On Facebook](https://www.facebook.com/seyhunak "Add Me On Facebook")
[Add Me On Google+](http://plus.ly/seyhunak "Add Me On Google+")

## Thanks
Twitter Bootstrap and all twitter-bootstrap-rails contributors
http://twitter.github.com/bootstrap


## License
Copyright (c) 2011 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
