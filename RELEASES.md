# Releases

Release notes for twitter-bootstrap-rails. For the terse per-change log, see
[CHANGELOG.md](CHANGELOG.md).

---

## 5.4.0 — 2 August 2026

**Bootstrap 5.3.8** · Rails 8, 7, 6, 5 · Sprockets and Propshaft · Ruby >= 3.0

The largest release since 5.0. It brings the vendored Bootstrap up to 5.3.8,
makes every code snippet in the Bootstrap 5.3 documentation reproducible from a
`rails g` command, fixes a bug that left Rails 8 apps with no Bootstrap at all,
and removes the Bootstrap 3-era Less and Glyphicons machinery.

> **This is a breaking release.** Read [Upgrading](#upgrading-from-53x) before
> bumping. Applications pinned to `~> 5.3.0` are unaffected until they opt in.

### Scope

| Area | Before | After |
|---|---|---|
| Bootstrap version | 5.3.3 vendored, 5.3.3 pinned separately in the layout | 5.3.8, declared once in `BOOTSTRAP_VERSION` |
| Asset pipeline | Sprockets assumed | Sprockets **and** Propshaft, detected at generate time |
| Generators | 4 | 18 |
| Docs snippets available as commands | 0 | 62 across 12 categories, plus the 5 Introduction-page snippets |
| Stylesheet toolchain | Less (Bootstrap 3 sources) + CSS | CSS only |
| Icons | Glyphicons (removed from Bootstrap in v4) | Bootstrap Icons sprite, 37 symbols |
| Test suite | 57 examples | 147 examples |

The gem version no longer tracks the Bootstrap version. `BOOTSTRAP_VERSION` is
the authoritative statement of which Bootstrap ships.

### Added

#### Snippet generators

Every snippet published at
[getbootstrap.com/docs/5.3/examples](https://getbootstrap.com/docs/5.3/examples/)
— **62 variants across 12 categories** — is now a command that writes an
`.html.erb` partial into your views:

```bash
rails g bootstrap:header                # first variant on the docs page
rails g bootstrap:header dark_search    # a specific variant
rails g bootstrap:header --list         # variants with descriptions
```

`bootstrap:header` · `bootstrap:hero` · `bootstrap:features` ·
`bootstrap:sidebar` · `bootstrap:footer` · `bootstrap:dropdown` ·
`bootstrap:list_group` · `bootstrap:modal` · `bootstrap:badge` ·
`bootstrap:breadcrumb` · `bootstrap:button` · `bootstrap:jumbotron`

Options on every snippet command: `--list`, `--as=NAME`, `--path=DIR`,
`--no-icons`. Variants are ordered as they appear on the docs page, so the
default is always the first example Bootstrap shows.

#### Bootstrap Icons sprite

36 of the 62 snippets reference icons through an SVG sprite that lives in the
Bootstrap docs *page chrome* rather than in the snippet markup — copying the
markup alone yields blank boxes. The 37 referenced symbols now ship as
`_bootstrap_icons.html.erb`, installed automatically alongside any snippet that
needs one. Render it once in your layout:

```erb
<%= render "shared/bootstrap_icons" %>
```

#### Introduction-page snippets

| Docs snippet | Command |
|---|---|
| Starter template | `rails g bootstrap:starter` |
| CDN CSS `<link>` | `rails g bootstrap:cdn --css` |
| CDN JS bundle `<script>` | `rails g bootstrap:cdn --js` |
| Popper + `bootstrap.js` separately | `rails g bootstrap:cdn --separate-popper` |
| Important globals | baked into every generated layout and the starter |

`bootstrap:starter` reproduces the docs' starter template byte for byte;
`bootstrap:cdn` prints tags for pasting into a layout you already own and writes
nothing to disk.

#### CDN mode

- `rails g bootstrap:install cdn` records the choice in
  `config/initializers/bootstrap.rb`; `bootstrap:layout` then emits CDN tags by
  default. `--cdn` / `--no-cdn` override per run.
- `rails g bootstrap:layout --cdn` emits jsDelivr tags with Subresource
  Integrity and `crossorigin`. `--separate-popper` swaps the single bundle for
  the Popper + `bootstrap.js` pair.

### Fixed

- **`bootstrap:install static` shipped no Bootstrap at all on Rails 8.**
  Propshaft, the Rails 8 default, has no Sprockets directives — a
  `//= require` line in a manifest is an inert comment, served verbatim to the
  browser. Pages returned 200 and the logs were clean; the CSS simply never
  arrived. The generator now detects the pipeline: on Propshaft it vendors the
  dist files and skips the meaningless manifests, and `bootstrap:layout` links
  them explicitly. Sprockets apps keep the manifest `require` behaviour.
- **A Bootstrap 3.1.1 stylesheet shadowed the Bootstrap 5 one.**
  `vendor/assets/stylesheets/twitter-bootstrap-static/bootstrap.css.erb` was
  Bootstrap **3.1.1** while occupying the same logical asset path as the
  Bootstrap 5 file in `app/assets`. Whichever the pipeline resolved first won.
  The stale copy is deleted.
- **Existing asset manifests were overwritten instead of amended.**
  `bootstrap:install` called `File.exist?` on paths relative to the working
  directory rather than the destination root, so an app's own
  `application.js` / `application.css` was never detected.
- **Silent no-op on manifests without a `require_self` anchor.** The insertion
  quietly did nothing; the generator now prints the line to add by hand.
- **Missing vendored assets failed silently.** `bootstrap:install` now raises a
  clear error instead of creating empty directories and copying nothing.
- **The generated layout loaded Bootstrap twice** — a hardcoded CDN link *and*
  `stylesheet_link_tag "application"`. It now emits one or the other.
- **`bootstrap.js` used a jQuery API dead since Bootstrap 4.** The template
  called `.tooltip()` / `.popover()`; it now uses the Bootstrap 5 JS API and has
  no jQuery dependency.
- **Haml and Slim layouts emitted Bootstrap 3 markup** (`navbar-default`,
  `.well`, `.icon-bar`) and an IE6-8 `html5shiv`. Both now match the ERB layout.
- **`add_locale` corrupted an existing locale file** by inserting the file's own
  contents into itself.
- **The built gem packaged `vendor/bundle`.** `s.files` globbed `vendor/**/*`,
  so on any machine that had run `bundle install --path vendor/bundle` the gem
  swallowed the entire bundle: 5,643 foreign files and 33 MB, versus 151 files
  and 168 KB.

### Improved

- **One source of truth for upstream coordinates.** The Bootstrap version, CDN
  URLs and Subresource Integrity hashes live only in
  `Twitter::Bootstrap::Rails::BOOTSTRAP_CDN`. A spec fails the build if any
  template hardcodes a `bootstrap@` version or a `sha384-` hash, so bumping
  Bootstrap is a one-file change plus re-vendoring two dist files.
- **Placeholder images are flagged.** Five snippets reference images that only
  resolve on Bootstrap's docs site (`hero centered`, `hero
  centered_screenshot`, `hero with_image`, `hero cropped_image`, `features
  custom_cards`). The generator now warns at generate time rather than leaving
  you with silent 404s.
- **Generated markup reads like handwritten code.** Snippets are re-indented
  from the docs' minified single-line output into properly nested partials.
- **Modernised layouts.** All three engines emit Bootstrap 5 navbar markup, the
  HTML5 doctype, `<html lang>` and the viewport meta, and a footer year that is
  evaluated at request time rather than baked in at generation.
- **Clearer generator output.** Every command reports what to render, and warns
  about icons and placeholder images where relevant.

### Removed

Bootstrap 5 has no Less build and dropped Glyphicons in v4, so the supporting
machinery is gone:

- `vendor/toolkit/` and `vendor/static-source/` (Bootstrap 3 Less sources)
- The `less-rails` and `execjs` dependencies, and the `post_install_message`
  telling users to install a JavaScript runtime
- The `rails g bootstrap:install less` argument and the
  `bootstrap_and_overrides.less` template
- `GlyphHelper#glyph` and the `glyphicons-halflings-regular` font files
- CoffeeScript support, including `--no-coffeescript` and `bootstrap.coffee`

### Upgrading from 5.3.x

```ruby
gem "twitter-bootstrap-rails", "~> 5.4.0"
```

1. **Using Less?** There is no replacement. Bootstrap 5 ships CSS only; move
   your customisations to Sass or plain CSS overrides.
   `rails g bootstrap:install less` is now `rails g bootstrap:install static`.
2. **Using `glyph(...)`?** Replace the call sites. Bootstrap Icons are
   available through the sprite the snippet generators install, or add the
   `bootstrap-icons` package directly.
3. **On Rails 8 / Propshaft?** Re-run `rails g bootstrap:install static` and
   then `rails g bootstrap:layout` — the layout step is what puts Bootstrap on
   the page.
4. Remove `less-rails` and any JavaScript runtime gem you added solely for
   Less compilation.

### Verification

This release was exercised end to end on a freshly generated Rails 8.0.5 app
(Propshaft + importmap), not only against the unit suite:

- Every generator in the documented flows runs (`install` in both modes,
  `layout`, `themed`, `starter`, `cdn`, and all 12 snippet generators); all
  scaffold pages return 200 with no server errors; form submission through the
  themed views persists records.
- Bootstrap CSS and JS are served and *take effect* — `window.bootstrap.Tooltip.VERSION`
  reports `5.3.8` and `.btn-primary` computes to `rgb(13, 110, 253)`.
- All 62 snippets render on one page with **zero unresolved icons**; the set
  references all 37 sprite symbols, none missing and none unused.
- The published artifact was installed from rubygems.org into a clean
  `GEM_HOME` and loaded successfully.
- 147 examples in the spec suite, including guards that keep the catalog, the
  template files and the icon sprite consistent with one another.

### Known issues

- Two pre-existing spec failures (`breadcrumbs_spec`, `modal_helper_spec`)
  predate this release and do not affect the packaged code paths.
- On Propshaft the generated layout does not emit `javascript_importmap_tags`,
  so an app relying on importmap for its own JavaScript should re-add that line
  after running `bootstrap:layout`. `bootstrap:layout` has always been a full
  layout replacement.
