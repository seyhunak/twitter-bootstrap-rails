# twitter-bootstrap-rails

Integrates Bootstrap 5 into Rails Asset Pipeline. Supports Rails 8, 7, 6, 5.

## Install

```ruby
# Gemfile
gem "twitter-bootstrap-rails"
```

```bash
bundle install
rails generate bootstrap:install static
```

## Generators

```bash
# Install Bootstrap assets
rails g bootstrap:install static

# Generate Bootstrap layout
rails g bootstrap:layout application

# Generate themed views for scaffold
rails g scaffold Task title:string done:boolean
rails db:migrate
rails g bootstrap:themed Tasks
```

## Quick Start

```bash
rails new myapp
cd myapp
echo 'gem "twitter-bootstrap-rails"' >> Gemfile
bundle install
rails generate bootstrap:install static
rails generate scaffold Task title:string description:text completed:boolean
rails db:migrate
rails generate bootstrap:themed Tasks
rails generate bootstrap:layout application
rails server
```

## License

MIT
