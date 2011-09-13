# Twitter Bootstrap for Rails 3
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites.
It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.
twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3 projects

## Rails 3.1
Include Bootstrap in Gemfile;
    <code>gem 'twitter-bootstrap-rails'</code>
or you can install from latest build;
    <code>gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'</code>
    
and run bundle install.

Add necessary stylesheet file to app/assets/stylesheets/application.css
<code>
    /* ...
	*= require bootstrap-1.2.0
    or
	*= require bootstrap-1.2.0.min
     * ...
    */
</code>

Not tested on Rails 3

## Credits
Seyhun Akyürek - seyhunak [at] gmail com

[Follow me on Twitter](http://twitter.com/seyhunak "Twitter")

## Contributors
<ul>
  <li>Daniel Morris</li>
  <li>Bradly Feeley</li>
</ul>

## Thanks
Thanks Twitter for Bootstrap
http://twitter.github.com/bootstrap

## License
Copyright (c) 2011 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.