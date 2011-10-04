# Twitter Bootstrap for Rails 3.1 Asset Pipeline
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites.
It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.

twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline


## Installing Gem
Include Bootstrap in Gemfile;

    gem 'twitter-bootstrap-rails'

or you can install from latest build;

    gem 'twitter-bootstrap-rails', :git => 'http://github.com/seyhunak/twitter-bootstrap-rails.git'

You can run bundle from command line

    bundle install


## Using with Less

Bootstrap was built with Preboot, an open-source pack of mixins and variables to be used in conjunction with Less,
a CSS preprocessor for faster and easier web development.

## Installing Less

Include Less in Gemfile;
   gem 'less'

Include less-rails in Gemfile;
   gem 'less-rails', :git => 'git://github.com/metaskills/less-rails.git'

## Using stylesheets with Less

You have to require Bootstrap LESS (bootstrap.less) in your application.css

	/*
	 *= require bootstrap
	*/

    /* Your stylesheets goes here... */

Now, you can override LESS files provided by Twitter Bootstrap

i.e
	@import "bootstrap";

	// Baseline grid
	@basefont:          13px;
	@baseline:          18px;


## Using javascripts

You have to require Bootstrap JS (bootstrap.js) in your application.js

    //= require bootstrap

	$(document).ready(function(){
      /* Your javascripts goes here... */
	});



## Changelog
<ul>
  <li>Version 0.0.5 deprecated</li>
  <li>Asset files updated to latest and removed version numbers</li>
  <li>Implemented Less::Rails Railtie to use with LESS</li>
</ul>

## Credits
Seyhun Akyürek - seyhunak [at] gmail com

[Follow me on Twitter](http://twitter.com/seyhunak "Twitter")


## Contributors
<ul>
  <li>Daniel Morris</li>
  <li>Bradly Feeley</li>
  <li>Guilherme Moreira</li>
  <li>Alex Behar</li>
</ul>


## Thanks
Twitter Bootstrap
http://twitter.github.com/bootstrap


## License
Copyright (c) 2011 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

