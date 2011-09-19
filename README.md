# Twitter Bootstrap for Rails 3
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites.
It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.



twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3 projects

## Rails 3.1
Include Bootstrap in Gemfile;

    gem 'twitter-bootstrap-rails'
    
or you can install from latest build;

    gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'
    
and run bundle install.

## Stylesheets

Add necessary stylesheet file to app/assets/stylesheets/application.css

    *= require bootstrap-1.3.0
    
or you can use minified version

    *= require bootstrap-1.3.0.min

## Javascripts

Add necessary javascripts files to app/assets/javascripts/application.js

    //= require bootstrap-alerts-1.3.0
    //= require bootstrap-dropdown-1.3.0
    //= require bootstrap-modal-1.3.0
    //= require bootstrap-popover-1.3.0
    //= require bootstrap-scrollspy-1.3.0
    //= require bootstrap-tabs-1.3.0
    //= require bootstrap-twipsy-1.3.0
        
Not tested on Rails 3

## Credits
Seyhun Akyürek - seyhunak [at] gmail com

[Follow me on Twitter](http://twitter.com/seyhunak "Twitter")

## Contributors
<ul>
  <li>Daniel Morris</li>
  <li>Bradly Feeley</li>
  <li>Guilherme Moreira</li>
</ul>

## Thanks
Thanks Twitter for Bootstrap
http://twitter.github.com/bootstrap

## License
Copyright (c) 2011 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.