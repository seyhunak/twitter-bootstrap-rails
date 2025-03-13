$:.push File.expand_path("../lib", __FILE__)
require "twitter/bootstrap/rails/version"

Gem::Specification.new do |s|
  s.name        = "twitter-bootstrap-rails"
  s.version     = Twitter::Bootstrap::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Seyhun Akyurek"]
  s.email       = ["seyhunak@gmail.com"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/seyhunak/twitter-bootstrap-rails"
  s.summary     = %q{Bootstrap CSS toolkit for Rails 7, 6, 5, 4.x Asset Pipeline}
  s.description = %q{twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 7, 6, 5, 4.x (also supports) Asset Pipeline}

  s.rubyforge_project = "twitter-bootstrap-rails"
  s.files = Dir["lib/**/*"] + Dir["vendor/**/*"] + Dir["app/**/*"] + ["Rakefile", "README.md"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'railties', '>= 5.0', '< 9.0'
  s.add_dependency 'actionpack', '>= 5.0', '< 9.0'
  s.add_dependency 'less-rails', '>= 3.0', '< 5.0'

  s.add_runtime_dependency 'execjs', '~> 2.7'
  s.add_development_dependency 'rails', '~> 5.0', '>= 5.0.1'
  s.add_development_dependency 'less', '~> 2.6'
  s.add_development_dependency 'therubyracer', '~> 0.12'

  s.post_install_message = "Important: You may need to add a javascript runtime to your Gemfile in order for bootstrap's LESS files to compile to CSS. \n\n" \
  "**********************************************\n\n" \
  "ExecJS supports these runtimes:\n\n" \
  "therubyracer - Google V8 embedded within Ruby\n\n" \
  "therubyrhino - Mozilla Rhino embedded within JRuby\n\n" \
  "Node.js\n\n" \
  "Apple JavaScriptCore - Included with Mac OS X\n\n" \
  "Microsoft Windows Script Host (JScript)\n\n" \
  "**********************************************\n"
end
