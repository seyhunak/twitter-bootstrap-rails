# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Rails engine gem that vendors Bootstrap and exposes it through `rails g bootstrap:*` generators, plus a few view helpers. Most of the gem is generators and their templates. It has no dummy app: specs run generators against a temp directory and helpers against bare ActionView.

The gem version (`VERSION`) and the Bootstrap version (`BOOTSTRAP_VERSION`) are independent. Both live in `lib/twitter/bootstrap/rails/version.rb`.

## Commands

```bash
bundle install                                          # Ruby version pinned in .tool-versions
bundle exec rspec                                       # full suite
bundle exec rspec spec/lib/generators/layout_generator_spec.rb      # one file
bundle exec rspec spec/lib/generators/layout_generator_spec.rb:42   # one example
bundle exec guard                                       # watch mode
```

`.bundle/config` sets `BUNDLE_PATH: vendor/bundle` (it overrides a `BUNDLE_PATH` env var). Gems are stored per Ruby ABI, so if `bundle exec` can't find gems or reports missing extensions, run `bundle install` under the active Ruby.

`Gemfile.lock` is gitignored, so dependency versions float between machines. The `Gemfile` pins `railties` and `actionpack` to the patched 8.1 line (`>= 8.1.4.1`) for development. The gemspec range (`>= 5.0, < 9.0`) is what gem users get, and it does not exclude vulnerable Rails versions.

**Do not use `rake`, `rake bundle`, or `rake build_static_stylesheets`.** `rake` defaults to `bundle`, not the specs, and `bundle` depends on `build_static_stylesheets`. That task is left over from the Less toolchain removed in 5.4.0: it needs the `less` gem and the deleted `vendor/toolkit`, and it `rm -rf`s `app/assets/stylesheets/twitter-bootstrap-static` before compiling. `rake bundle` also runs `rm *.gem` in the repo root. Use `gem build twitter-bootstrap-rails.gemspec` to build the gem.

## Architecture

Two namespaces:

- `Twitter::Bootstrap::Rails` (`lib/twitter/bootstrap/rails/`): runtime code, including the engine, version constants, and config. Inside it `Rails` means this module, so write `::Rails` for the framework.
- `Bootstrap::Generators` (`lib/generators/bootstrap/<name>/<name>_generator.rb`): generators. Rails finds them by that path convention.

### Single source of truth for Bootstrap versions

`BOOTSTRAP_CDN` in `version.rb` holds every CDN URL and SRI hash. `CdnTags` (`lib/generators/bootstrap/cdn_tags.rb`) renders them for the `layout`, `starter`, and `cdn` generators. `no_hardcoded_versions_spec.rb` fails if any template contains `bootstrap@` or `sha384-`.

To bump Bootstrap, edit `version.rb` and re-vendor all four dist files. The same spec checks each file's banner against `BOOTSTRAP_VERSION`:

- `vendor/assets/stylesheets/twitter/bootstrap/bootstrap.min.css`
- `vendor/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js`
- `app/assets/stylesheets/twitter-bootstrap-static/bootstrap.css`
- `app/assets/javascripts/twitter/bootstrap/bootstrap.min.js`

### Asset modes and pipelines

These two settings combine, and `install` and `layout` have to agree on them:

- **Mode (`static` or `cdn`):** `bootstrap:install cdn` writes an initializer setting `Twitter::Bootstrap::Rails.asset_mode = :cdn`. `bootstrap:layout` reads that as its default, and `--cdn` / `--no-cdn` override it.
- **Pipeline (`config.rb`):** detected at generate time from `defined?(::Propshaft)` / `defined?(::Sprockets)`. Under Sprockets, `install` adds `require` directives to the manifests. Propshaft has no directives, so `install` only copies the files and the `layout` template must link them by name (`stylesheet_arguments`, `javascript_arguments`).

### Two kinds of template

- **Snippet templates** (`snippets/templates/<category>/<variant>.html.erb`) are copied verbatim with `copy_file`, and their content comes from the Bootstrap docs.
- **`layout` templates** go through `template`, so they are evaluated at generate time: `<%= %>` runs in the generator and `<%%= %>` is emitted into the host app. `layout` has ERB, Haml, and Slim versions, as do the `themed` templates, so a markup change usually applies to all three.

### Snippet generators

`SnippetBase` (`snippets/snippet_base.rb`) holds all behaviour. Each subclass only declares `snippet_category "..."`. `SnippetCatalog` is the registry: `GENERATORS` maps generator name to docs category, and `VARIANTS` lists each category's variants in docs-page order. The first variant is the default.

- **Adding a variant:** add the template and a catalog entry, and update the README table.
- **Adding a category:** also add `<name>/<name>_generator.rb`. `generator_spec_helper.rb` requires generators from `GENERATORS`, and a catalog spec pins the exact list of categories.

`snippet_generators_spec.rb` keeps the catalog and templates in sync. The `:icons` and `:images` flags must match the markup (`xlink:href="#"`, docs-site image names), every referenced icon must exist in `icons/_bootstrap_icons.html.erb`, and docs-page chrome such as `b-example-divider` must be stripped.

### Helpers

`engine.rb` loads helpers by explicit `require_relative` and registers them from a hardcoded list, so a new helper in `app/helpers/` must be added there. `FormErrorsHelper` is included into `FormBuilder` and `Breadcrumbs` into `ActionController::Base`. Breadcrumbs only aliases the unprefixed `add_breadcrumb` when `BreadcrumbsOnRails` is absent, and the `add_bootstrap_breadcrumb` name always works.

## Testing

Generator specs use `spec/support/generator_spec_helper.rb`:

- `run_generator(klass, args)` runs against a temp destination and returns the captured output. It passes `:debug => true` so specs can assert on raised `Thor::Error`s.
- `write_destination` / `read_destination` / `destination_exist?` work with files in that destination.
- `stub_rails_application` stands in for `Rails.application`, which `layout` reads for the app name and template engine.
- Set `Twitter::Bootstrap::Rails.asset_pipeline = :propshaft` to test Propshaft paths. An `after` hook resets it and `asset_mode`.

Generators must resolve host-app paths against `destination_root`, not the working directory (see `exists_in_app?` in `install_generator.rb`).

Specs mock with rspec-mocks (`allow`, `expect(...).to receive`). `I18n.t` takes keyword arguments, so expectations on it need `with(name, **options)`.

## Packaging

The gemspec globs only `vendor/assets/**/*`, on purpose: `vendor/**/*` would package `vendor/bundle` into the gem.

## Outdated files

- `WARP.md` predates 5.4.0. It describes Less, Glyphicons, CoffeeScript, `vendor/toolkit`, and `glyph_helper`, all of which are gone. Trust the code and `RELEASES.md` over it.
- `.travis.yml` targets Ruby 2.7 and 3.0, but the gemspec requires Ruby >= 3.0 and `.tool-versions` pins 3.3.5.

`CHANGELOG.md` is the terse per-change log and `RELEASES.md` holds the long release notes. `CONTRIBUTING.md` requires feature requests to come with a patch that includes tests.
