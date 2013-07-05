source "http://rubygems.org"

# Specify your gem's dependencies in twitter-bootstrap-rails.gemspec
gemspec
gem 'less-rails', :path => ENV['LESS_RAILS_SOURCE'] if ENV['LESS_RAILS_SOURCE']
gem 'activesupport', '< 4.0.0' if RUBY_VERSION < '1.9.3'

group :test do
  gem 'minitest'
  gem 'mocha'
  gem 'rake'
  gem 'turn'
  gem 'coveralls'
  gem 'rspec'
end
