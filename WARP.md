# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Ruby gem (`twitter-bootstrap-rails`) that integrates Bootstrap CSS toolkit into Rails Asset Pipeline for Rails 4.x through 8. It provides both Less and static CSS distribution options, along with Rails generators and view helpers.

## Development Commands

### Gem Development
```bash
# Install dependencies
bundle install

# Build and install the gem locally
bundle exec rake bundle

# Build static stylesheets from Less sources
bundle exec rake build_static_stylesheets

# Run tests
bundle exec rspec

# Run tests with Guard (watch mode)
bundle exec guard
```

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/lib/breadcrumbs_spec.rb

# Run tests with color and documentation format
bundle exec rspec --color --format doc
```

## Architecture

### Module Structure
The gem follows a nested module structure: `Twitter::Bootstrap::Rails`

**Core components:**
- `lib/twitter/bootstrap/rails/engine.rb` - Rails Engine that initializes the gem and registers helpers
- `lib/twitter/bootstrap/rails/breadcrumbs.rb` - Breadcrumb functionality with BreadcrumbsOnRails compatibility
- `lib/twitter/bootstrap/rails/bootstrap.rb` - Main bootstrap functionality loader

### Generators
Located in `lib/generators/bootstrap/`:
- **install** - Installs Bootstrap assets (Less or static CSS)
- **layout** - Generates Bootstrap-compatible layouts (supports ERB, Haml, Slim)
- **themed** - Generates Bootstrap-themed scaffold views for a resource
- **partial** - Generates Bootstrap partials

Generator invocation:
```bash
rails generate bootstrap:install less         # or 'static'
rails generate bootstrap:layout [LAYOUT_NAME]
rails generate bootstrap:themed [RESOURCE_NAME]
```

### View Helpers
Located in `app/helpers/`:
- **navbar_helper.rb** - `nav_bar`, `menu_group`, `menu_item`, `drop_down` helpers
- **modal_helper.rb** - `modal_dialog` helper
- **bootstrap_flash_helper.rb** - `bootstrap_flash` for flash messages
- **badge_label_helper.rb** - `badge`, `tag_label` helpers
- **glyph_helper.rb** - `glyph` helper for icons
- **flash_block_helper.rb** - Legacy flash block support
- **form_errors_helper.rb** - Form error handling
- **twitter_breadcrumbs_helper.rb** - `render_breadcrumbs`, `add_breadcrumb` helpers

All helpers are automatically registered with ActionController::Base through the Engine initializer.

### Asset Structure
- `vendor/toolkit/` - Bootstrap Less source files
- `vendor/static-source/` - Source Less files for static CSS compilation
- `app/assets/javascripts/twitter/bootstrap/` - Individual Bootstrap JS components
- `app/assets/stylesheets/twitter-bootstrap-static/` - Pre-compiled static CSS
- `vendor/assets/stylesheets/` - Additional static stylesheet assets

### Two Distribution Modes

**Less Mode:**
- Requires `less-rails` gem and JavaScript runtime (e.g., therubyracer)
- Generates `bootstrap_and_overrides.css.less` in consuming apps
- Allows variable customization and mixin usage
- Less paths configured via Engine initializer

**Static Mode:**
- No additional dependencies
- Pre-compiled CSS files
- Generated via `rake build_static_stylesheets` task
- Uses Less::Parser to compile vendor/static-source/*.less files

### Breadcrumbs Compatibility
The breadcrumbs module detects `BreadcrumbsOnRails` gem and adapts:
- If detected: methods use `bootstrap` prefix (`add_bootstrap_breadcrumb`, `render_bootstrap_breadcrumbs`)
- If not detected: backward-compatible aliases without prefix

### Test Structure
- Tests use RSpec with rspec-html-matchers for view helper testing
- Mocha for mocking
- Spec files mirror lib structure: `spec/lib/twitter_bootstrap_rails/`
- Run with color and progress format by default (.rspec config)

## Rails Integration Notes

- Compatible with Rails 5.0+ through 9.0
- CoffeeScript support is optional (can be disabled with `--no-coffeescript`)
- Respects `Rails.configuration.app_generators.rails[:javascript_engine]`
- Initializers run after `less-rails.after.load_config_initializers`
