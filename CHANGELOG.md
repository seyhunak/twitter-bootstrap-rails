## 5.4.0

Bootstrap **5.3.8**. The gem version no longer tracks the Bootstrap version;
`Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION` is the authoritative statement of
which Bootstrap ships.

### Breaking changes

- **Less is gone.** The `rails g bootstrap:install less` argument, the
  `bootstrap_and_overrides.less` template, the Bootstrap 3 Less sources under
  `vendor/toolkit` and `vendor/static-source`, and the `less-rails` and `execjs`
  dependencies have all been removed. Bootstrap 5 has no Less build.
- **Glyphicons are gone.** `GlyphHelper#glyph` and the
  `glyphicons-halflings-regular` font files have been removed. Bootstrap dropped
  Glyphicons in v4; the helper emitted markup for icons that no longer resolve.
- **CoffeeScript support removed**, along with the `--no-coffeescript` option and
  the `bootstrap.coffee` template.
- `rails g bootstrap:install` now takes `static` (default) or `cdn`.

### Fixed

- `vendor/assets/stylesheets/twitter-bootstrap-static/bootstrap.css.erb` was
  **Bootstrap 3.1.1** while occupying the same logical asset path as the
  Bootstrap 5 file in `app/assets`. Whichever the asset pipeline resolved first
  won. The stale Bootstrap 3 copy has been deleted.
- `bootstrap:install` checked `File.exist?` on paths relative to the working
  directory rather than the destination root, so an app's existing
  `application.js` / `application.css` were never detected and were overwritten
  with the gem's template instead of having a require line inserted.
- `bootstrap:install` now raises a clear error when a vendored dist file is
  missing from the gem, instead of creating empty directories and copying nothing.
- **`bootstrap:install static` shipped no Bootstrap at all on Rails 8.** Propshaft
  (the Rails 8 default) has no Sprockets directives — a `//= require` line in a
  manifest is an inert comment, served verbatim to the browser. The documented
  default flow produced a completely unstyled app. `bootstrap:install` now detects
  the pipeline: on Propshaft it vendors the dist files and skips the meaningless
  manifests, and `bootstrap:layout` links them explicitly with
  `stylesheet_link_tag "twitter/bootstrap/bootstrap.min"` /
  `javascript_include_tag "twitter/bootstrap/bootstrap.bundle.min"`. Sprockets
  apps keep the manifest `require` behaviour.
- On Sprockets apps whose `application.css` has no `require_self` directive to
  anchor to, the require insertion silently did nothing. The generator now
  prints the line to add by hand.
- `add_locale` re-inserted the locale file's own contents into itself when
  `config/locales/en.bootstrap.yml` already existed.
- The generated layout loaded Bootstrap twice — a hardcoded CDN link *and*
  `stylesheet_link_tag "application"`. It now emits one or the other.
- The `bootstrap.js` template called jQuery `.tooltip()` / `.popover()`, which
  has not worked since Bootstrap 4. It now uses the Bootstrap 5 JS API.
- The Haml and Slim layouts still emitted Bootstrap 3 markup (`navbar-default`,
  `.well`, `.icon-bar`) and an IE6-8 html5shiv. Both now match the ERB layout.

### Added

- **Snippet generators.** Every snippet published at
  [getbootstrap.com/docs/5.3/examples](https://getbootstrap.com/docs/5.3/examples/)
  — 62 variants across 12 categories — is now a command that writes an `.html.erb`
  partial: `bootstrap:header`, `bootstrap:hero`, `bootstrap:features`,
  `bootstrap:sidebar`, `bootstrap:footer`, `bootstrap:dropdown`,
  `bootstrap:list_group`, `bootstrap:modal`, `bootstrap:badge`,
  `bootstrap:breadcrumb`, `bootstrap:button`, and `bootstrap:jumbotron`.
  Each takes a variant name (`rails g bootstrap:header dark_search`), defaults to
  the first variant on the docs page, and supports `--list`, `--as`, `--path`,
  and `--no-icons`. Variant order matches the docs page order.
- Snippets that reference placeholder images from the Bootstrap docs site (which
  404 in a generated app) now warn at generate time instead of failing silently.
- The Bootstrap Icons sprite used by 36 of those snippets ships as
  `_bootstrap_icons.html.erb`, installed automatically alongside any snippet that
  needs it. Render it once in your layout.
- `rails g bootstrap:starter` — writes the starter template from the Bootstrap
  docs to `public/bootstrap-starter.html` (`--path` to override).
- `rails g bootstrap:cdn` — prints the CDN tags for pasting into your own layout.
  `--css`, `--js`, `--separate-popper`.
- `rails g bootstrap:layout --cdn` — link Bootstrap from jsDelivr with Subresource
  Integrity instead of the asset pipeline. `--separate-popper` emits the Popper +
  `bootstrap.js` pair instead of the bundle.
- `rails g bootstrap:install cdn` — records CDN mode in
  `config/initializers/bootstrap.rb`, which `bootstrap:layout` then defaults to.

<ul>
  <li>Version 5.3.1 - Documentation and packaging updates only; no library code changes since 5.3.0</li>
  <li>Version 5.3.0 - Bootstrap 5.3 assets, new generators, static asset fixes, requires Ruby >= 3.0, less-rails ~> 4.0</li>
  <li>Version 5.1.0 - Added Rails 8 compatibility</li>
  <li>Version 5.0.0 - Current version</li>
  <li>Version 0.0.5 deprecated</li>
  <li>Asset files updated to latest and removed version numbers</li>
  <li>Implemented Less::Rails Railtie to use with LESS</li>
  <li>Fixed railtie to only initialize Less when installed</li>
  <li>New branch for the static version of Bootstrap (w/o Less) - check static branch</li>
  <li>Added path to support heroku deploy</li>
  <li>Rake precompile issue fixed</li>
  <li>Updated asset files to 1.4.0</li>
  <li>Updated dependency less-rails (now requires 2.1.0)</li>
  <li>Added generators</li>
  <li>Fixed generators</li>
  <li>Fixed class name conflicts from (bootstrap.js.coffee)</li>
  <li>Fixed jquery-rails gem version dependency</li>
  <li>Updated asset files</li>
  <li>Added new generators (install, layout and themed)</li>
  <li>Compatibility to Rails 3.2</li>
  <li>Transitioning to 2.0</li>
  <li>Released gem v.2.0rc0</li>
  <li>Added Haml and Slim support</li>
  <li>Added Responsive layout support</li>
  <li>Fixes and release 2.0.0</li>
  <li>Updated to v2.0.1, versioned v2.0.1.0</li>
  <li>Released gem v.2.0.3</li>
  <li>Released gem v.2.0.4</li>
  <li>Released gem v.2.0.5</li>
  <li>Added SimpleForm support</li>
  <li>Added FontAwesome support</li>
  <li>Released gem v.2.0.6</li>
  <li>Released gem v.2.0.7</li>
  <li>Released gem v.2.0.8</li>
  <li>Released gem v.2.0.9 (Bootstrap 2.0.4 and FontAwesome 2.0 support)</li>
  <li>Released gem v.2.1.0 (JRuby support)</li>
  <li>Released gem v.2.1.1 (minor fixes)</li>
  <li>Flash block message helper added</li>
  <li>Released gem v.2.1.2 (minor fixes and updated to Twitter Bootstrap 2.1.0)</li>
  <li>Released gem v.2.1.3 (minor fixes and updated to Twitter Bootstrap 2.1.1)</li>
  <li>Released gem v.2.1.4 (minor fixes)</li>
  <li>Released gem v.2.1.5 (minor fixes, install generator detects JavaScript template engine, updated to Twitter Bootstrap 2.2.1)</li>
  <li>Released gem v.2.1.6 (minor fixes)</li>
  <li>Added static stylesheets support</li>
  <li>Released gem v.2.1.8 and updated to Twitter Bootstrap 2.2.2</li>
  <li>Released gem v.2.1.9</li>
  <li>Released gem v.2.2.0 (Font Awesome 3)</li>
  <li>Released gem v.2.2.1 (minor fixes and updates)</li>
  <li>Released gem v.2.2.2 (Bootstrap 2.3.0)</li>
  <li>Released gem v.2.2.3 (Minor fixes)</li>
  <li>Released gem v.2.2.4 (Minor fixes)</li>
  <li>Released gem v.2.2.5 (Bootstrap 2.3.1)</li>
  <li>Released gem v.2.2.6</li>
  <li>Released gem v.2.2.7 (Fixes)</li>
  <li>Releases gem v.2.2.8</li>
  <li>Releases gem v.3.2.1</li>
  <li>Releases gem v.3.2.2</li>
  <li>Dropped FontAwesome support, see #889</li>
  <li>Releases gem v.4.0.0> (master changes)<li>
</ul>
