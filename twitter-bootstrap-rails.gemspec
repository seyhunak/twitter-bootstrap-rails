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
  s.summary     = %q{Bootstrap 5 for Rails 8 and 7.1+: generators, helpers, and checks for coding agents}
  s.description = %q{Vendors Bootstrap 5 for Propshaft, Sprockets, importmap or the CDN, and adds generators for layouts, scaffolds and every snippet from the Bootstrap docs, plus view helpers and a doctor that checks an app's setup.}
  s.required_ruby_version = '>= 3.0'

  s.metadata = {
    "source_code_uri" => s.homepage,
    "changelog_uri" => "#{s.homepage}/blob/master/CHANGELOG.md",
    "bug_tracker_uri" => "#{s.homepage}/issues",
    "documentation_uri" => "#{s.homepage}#readme",
    "funding_uri" => "https://opencollective.com/seyhunak",
    "rubygems_mfa_required" => "true"
  }

  # Only vendor/assets ships. Globbing vendor/**/* would sweep in vendor/bundle
  # on any machine that has run `bundle install --path vendor/bundle`, which
  # silently packages the whole bundle into the gem.
  s.files = Dir["lib/**/*"] + Dir["vendor/assets/**/*"] + Dir["app/**/*"] +
            ["Rakefile", "README.md", "CHANGELOG.md"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # 7.1 is the oldest Rails line this gem is tested on. Older lines no longer get
  # security fixes.
  s.add_dependency 'railties', '>= 7.1', '< 9.0'
  s.add_dependency 'actionpack', '>= 7.1', '< 9.0'
end
