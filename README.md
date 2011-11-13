# Twitter Bootstrap for Rails 3.1 Asset Pipeline
Bootstrap is a toolkit from Twitter designed to kickstart development of webapps and sites.
It includes base CSS and HTML for typography, forms, buttons, tables, grids, navigation, and more.

twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline


## Using Static CSS, JS (w/o Less)

twitter-bootstrap-rails has seperate branch (w/o Less) that just serves latest static CSS, JS files.

You can install from latest build (from branch);

    gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git", :branch => "static"

You can run bundle from command line

    bundle install


## Using stylesheets

You have to require Bootstrap CSS (bootstrap.css) in your application.css

	/*
	 *= require bootstrap 
	*/
	
	or
	
	/*
	 *= require bootstrap.min
	*/

  /* Your stylesheets goes here... */

## Using javascripts

You have to require Bootstrap JS (bootstrap.js) in your application.js

  //= require bootstrap-alerts
  //= require bootstrap-dropdown
  //= require bootstrap-modal
  //= require bootstrap-twipsy 
  //= require bootstrap-popover
  //= require bootstrap-scrollspy
  //= require bootstrap-tabs 
  //= require bootstrap-buttons  
  
	$(document).ready(function(){
      /* Your javascripts goes here... */
	});


## Using with coffeescript
Using Twitter Bootstrap with the CoffeeScript is easy.
Just create a application.js.coffee file to /app/assets/javascripts/ folder and put lines below.

	$ ->
	  $("body > .topbar").scrollSpy()
	$ ->
	  $(".tabs").tabs()
	$ ->
	  $("a[rel=twipsy]").twipsy live: true
	$ ->
	  $("a[rel=popover]").popover offset: 10
	$ ->
	  $(".topbar-wrapper").dropdown()
	$ ->
	  $(".alert-message").alert()
	$ ->
	  domModal = $(".modal").modal(
		backdrop: true
		closeOnEscape: true
	  )
	  $(".open-modal").click ->
		domModal.toggle()

## Credits
Seyhun Akyürek - seyhunak [at] gmail com

[Follow me on Twitter](http://twitter.com/seyhunak "Twitter")


## Thanks
Twitter Bootstrap
http://twitter.github.com/bootstrap


## License
Copyright (c) 2011 Seyhun Akyürek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

