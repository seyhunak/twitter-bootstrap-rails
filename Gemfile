source "http://rubygems.org"

# Specify your gem's dependencies in twitter-bootstrap-rails.gemspec
gemspec

# Develop and test against the patched Rails: 8.1.4.1 fixes 21 security issues.
# Gemfile.lock is gitignored, so this is what keeps contributors on it.
gem 'railties', '~> 8.1.4', '>= 8.1.4.1'
gem 'actionpack', '~> 8.1.4', '>= 8.1.4.1'

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
