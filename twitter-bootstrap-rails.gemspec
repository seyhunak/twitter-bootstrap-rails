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
  s.summary     = %q{Bootstrap 5 CSS toolkit for Rails 8, 7, 6, 5 Asset Pipeline}
  s.description = %q{twitter-bootstrap-rails project integrates Bootstrap 5 CSS toolkit for Rails 8, 7, 6, 5 (also supports) Asset Pipeline}
  s.required_ruby_version = '>= 3.0'

  # Only vendor/assets ships. Globbing vendor/**/* would sweep in vendor/bundle
  # on any machine that has run `bundle install --path vendor/bundle`, which
  # silently packages the whole bundle into the gem.
  s.files = Dir["lib/**/*"] + Dir["vendor/assets/**/*"] + Dir["app/**/*"] +
            ["Rakefile", "README.md", "CHANGELOG.md"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'railties', '>= 5.0', '< 9.0'
  s.add_dependency 'actionpack', '>= 5.0', '< 9.0'
end
