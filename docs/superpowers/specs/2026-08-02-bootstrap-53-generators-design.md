# Bootstrap 5.3.8 adaptation and Introduction-page snippet generators

Date: 2026-08-02
Status: Approved

## Goal

Bring `twitter-bootstrap-rails` up to Bootstrap 5.3.8, and make every code snippet
on <https://getbootstrap.com/docs/5.3/getting-started/introduction/> reproducible
through a `rails g bootstrap:*` command.

## Background

The gem is currently inconsistent and partly broken:

- `app/assets/stylesheets/twitter-bootstrap-static/bootstrap.css` vendors Bootstrap
  **5.3.3**; the generated layout CDN-pins **5.3.3** separately. Two places to bump.
- `InstallGenerator#copy_bootstrap_assets` globs
  `vendor/assets/stylesheets/twitter/bootstrap` and
  `vendor/assets/javascripts/twitter/bootstrap`. **Neither path exists.** `Dir.glob`
  returns `[]`, so the method creates two empty directories in the host app and
  copies nothing, silently.
- `vendor/toolkit/**/*.less` and `vendor/static-source/*.less` are the Bootstrap **3**
  Less source. Bootstrap 5 has no Less build. The gemspec still hard-depends on
  `less-rails ~> 4.0` and `execjs ~> 2.7`, and ships a `post_install_message` telling
  users to install a JavaScript runtime for Less compilation.
- `app/assets/fonts/glyphicons-halflings-regular.*` and `app/helpers/glyph_helper.rb`
  support Glyphicons, which Bootstrap dropped in v4.

## Scope

In scope: the five snippets on the Introduction page only.

1. CDN CSS `<link>`
2. CDN JS bundle `<script>`
3. The starter HTML template
4. Popper + `bootstrap.js` as separate `<script>` tags
5. "Important globals" — HTML5 doctype, `<html lang>`, viewport meta

Out of scope: component snippets from the rest of the Bootstrap docs (alerts, cards,
modals, ...). Those may become partials in a later pass.

## Design

### 1. Single source of truth for upstream coordinates

`lib/twitter/bootstrap/rails/version.rb` carries the Bootstrap version and the CDN
URLs with their integrity hashes. No template hardcodes either.

```ruby
module Twitter
  module Bootstrap
    module Rails
      VERSION = "5.4.0"
      BOOTSTRAP_VERSION = "5.3.8"
      POPPER_VERSION = "2.11.8"

      BOOTSTRAP_CDN = {
        css: {
          url: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css",
          integrity: "sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
        },
        bundle: {
          url: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js",
          integrity: "sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        },
        js: {
          url: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js",
          integrity: "sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y"
        },
        popper: {
          url: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js",
          integrity: "sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
        }
      }.freeze
    end
  end
end
```

Bumping Bootstrap becomes a one-file change plus re-vendoring the two dist files.

A shared module `Bootstrap::Generators::CdnTags` renders tag strings from this hash
and is mixed into the generators that need them. It exposes `css_tag`,
`bundle_tag`, `popper_tag`, and `js_tag`, each returning the exact markup from the
docs page.

### 2. Snippet-to-command mapping

| Docs snippet | Command |
|---|---|
| Starter template | `rails g bootstrap:starter` |
| Important globals | baked into every layout and starter template |
| CDN CSS link | `rails g bootstrap:layout --cdn` |
| CDN JS bundle | `rails g bootstrap:layout --cdn` |
| Popper + bootstrap.js separately | `rails g bootstrap:layout --cdn --separate-popper` |
| Any of the above, as text | `rails g bootstrap:cdn` |

### 3. `bootstrap:install`

Signature: `rails g bootstrap:install [static|cdn]`, default `static`.

- `static` (default) vendors Bootstrap 5.3.8 into the host app's asset pipeline and
  adds the `require` lines to the CSS/JS manifests.
- `cdn` skips vendoring entirely and writes `config/initializers/bootstrap.rb`
  containing `Twitter::Bootstrap::Rails.asset_mode = :cdn`. `bootstrap:layout` reads
  `Twitter::Bootstrap::Rails.asset_mode` to pick its default; passing `--cdn` or
  `--no-cdn` overrides it. The accessor is defined in
  `lib/twitter/bootstrap/rails/bootstrap.rb` as an `mattr_accessor` defaulting to
  `:static`, so the layout generator works whether or not the initializer exists.

Behaviour changes:

- `copy_bootstrap_assets` is fixed to read from paths that exist. Bootstrap 5.3.8's
  `bootstrap.min.css` and `bootstrap.bundle.min.js` are downloaded from jsDelivr,
  verified against the integrity hashes above, and committed to
  `vendor/assets/stylesheets/twitter-bootstrap-static/` and
  `vendor/assets/javascripts/twitter/bootstrap/` respectively. The generator raises
  a clear error if a source file is missing rather than creating empty directories.
- The `less` argument value, the `bootstrap_and_overrides.less` template, the
  `--no-coffeescript` option, and the `bootstrap.coffee` template are removed.

### 4. `bootstrap:layout`

Gains two options:

- `--cdn` / `--no-cdn` — emit the jsDelivr `<link>`/`<script>` tags with integrity
  and `crossorigin` attributes, instead of `stylesheet_link_tag` /
  `javascript_include_tag`. Default comes from the mode recorded by
  `bootstrap:install`, falling back to vendored.
- `--separate-popper` — with `--cdn`, emit the Popper + `bootstrap.min.js` pair
  instead of the single bundle. Ignored with a warning when `--cdn` is not set,
  since the vendored path ships the bundle.

All three template engines (erb, haml, slim) support both options.

### 5. `bootstrap:starter` (new)

Writes the Introduction page's starter template to `public/bootstrap-starter.html`
— a standalone HTML document with no ERB, so `public/` is where it can be opened
directly in a browser. `--path=PATH` overrides the destination. The file is the docs
snippet verbatim, with the version and integrity values interpolated from the
constants.

### 6. `bootstrap:cdn` (new)

Prints tags to stdout rather than writing a file, for pasting into a layout the user
already owns. Writes nothing to disk.

- `rails g bootstrap:cdn` — CSS link + JS bundle script
- `rails g bootstrap:cdn --css` — CSS link only
- `rails g bootstrap:cdn --js` — JS bundle script only
- `rails g bootstrap:cdn --separate-popper` — Popper + bootstrap.js pair

### 7. Removals

Deleted outright, since nothing in Bootstrap 5 uses them:

- `vendor/toolkit/` (Bootstrap 3 Less source)
- `vendor/static-source/` (Bootstrap 3 Less source)
- `app/assets/fonts/glyphicons-halflings-regular.*`
- `app/helpers/glyph_helper.rb` and `spec/lib/twitter_bootstrap_rails/glyph_helper_spec.rb`
- `lib/generators/bootstrap/install/templates/bootstrap_and_overrides.less`
- `lib/generators/bootstrap/install/templates/bootstrap.coffee`
- gemspec: the `less-rails` and `execjs` dependencies, and `post_install_message`

`GlyphHelper` is removed rather than deprecated because its icon font is being
deleted in the same pass; leaving the helper would emit markup for glyphs that no
longer resolve.

## Versioning

Gem version goes to **5.4.0**. Dropping Less, Glyphicons, and the `less` install
argument breaks existing users, so this cannot be a patch. The gem version
consequently stops tracking the Bootstrap version; `BOOTSTRAP_VERSION` is the
authoritative statement of which Bootstrap ships.

## Testing

New specs under `spec/lib/generators/`, using `Rails::Generators::TestCase` against
a tmp destination root:

- `install_generator_spec` — `static` vendors both dist files into the destination
  and inserts the manifest `require` lines; `cdn` vendors nothing and writes the
  initializer; a missing vendored source raises rather than silently no-opping.
- `layout_generator_spec` — default emits `stylesheet_link_tag`; `--cdn` emits the
  CSS link and bundle script with the exact URL and integrity from the constants;
  `--cdn --separate-popper` emits the Popper and `bootstrap.min.js` pair and no
  bundle; `--separate-popper` without `--cdn` warns. Repeated per engine.
- `starter_generator_spec` — output is byte-identical to the docs snippet once the
  version and hashes are interpolated; `--path` is honoured.
- `cdn_generator_spec` — each flag prints the expected tags and writes no file.
- A guard spec asserting no template contains a hardcoded `bootstrap@` version
  string, so the constants stay the only source.

Existing helper specs continue to run unchanged, minus the deleted glyph spec.

## Documentation

README: update the generator table with `bootstrap:starter` and `bootstrap:cdn` and
the new `bootstrap:layout` options. CHANGELOG: a 5.4.0 entry with a Breaking Changes
section covering the Less, Glyphicons, coffeescript, and `bootstrap:install less`
removals, and the fixed vendoring bug.
