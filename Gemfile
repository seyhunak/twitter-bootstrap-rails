source "http://rubygems.org"

# Specify your gem's dependencies in twitter-bootstrap-rails.gemspec
gemspec
gem 'less-rails', '~> 4.0.0'
gem 'activesupport', '< 5.0.1' if RUBY_VERSION < '2.1.3'

group :development, :test do
  gem 'rb-readline'
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
end
group :test do
  gem 'minitest'
  gem 'mocha'
  gem 'rake'
  gem 'turn'
  gem 'coveralls'
  gem 'rspec'
  gem 'rspec-html-matchers'
  gem 'rspec-activemodel-mocks'
end
