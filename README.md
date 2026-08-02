# twitter-bootstrap-rails

[![Gem Version](https://badge.fury.io/rb/twitter-bootstrap-rails.svg)](http://badge.fury.io/rb/twitter-bootstrap-rails)
[![GitHub stars](https://img.shields.io/github/stars/seyhunak/twitter-bootstrap-rails.svg)](https://github.com/seyhunak/twitter-bootstrap-rails/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/seyhunak/twitter-bootstrap-rails.svg)](https://github.com/seyhunak/twitter-bootstrap-rails/network)
[![GitHub issues](https://img.shields.io/github/issues/seyhunak/twitter-bootstrap-rails.svg)](https://github.com/seyhunak/twitter-bootstrap-rails/issues)

Integrates Bootstrap 5.3.8 into Rails Asset Pipeline. Supports Rails 8, 7, 6, 5.

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

Every code snippet on the
[Bootstrap 5.3 Introduction page](https://getbootstrap.com/docs/5.3/getting-started/introduction/)
is reproducible from a command:

| Docs snippet | Command |
|---|---|
| Starter template | `rails g bootstrap:starter` |
| CDN CSS `<link>` | `rails g bootstrap:cdn --css` |
| CDN JS bundle `<script>` | `rails g bootstrap:cdn --js` |
| Popper + `bootstrap.js` separately | `rails g bootstrap:cdn --separate-popper` |
| Important globals (doctype, `lang`, viewport) | baked into every generated layout and the starter template |

```bash
# Install Bootstrap assets into the asset pipeline
rails g bootstrap:install static

# ...or load Bootstrap from the jsDelivr CDN instead
rails g bootstrap:install cdn

# Generate a Bootstrap layout
rails g bootstrap:layout application

# ...linking Bootstrap from the CDN, with Subresource Integrity
rails g bootstrap:layout application --cdn

# ...using Popper and bootstrap.js separately rather than the bundle
rails g bootstrap:layout application --cdn --separate-popper

# Write the starter template from the Bootstrap docs
rails g bootstrap:starter                    # -> public/bootstrap-starter.html
rails g bootstrap:starter --path=public/demo.html

# Print CDN tags to paste into a layout you already own (writes nothing)
rails g bootstrap:cdn

# Generate themed views for scaffold
rails g scaffold Task title:string done:boolean
rails db:migrate
rails g bootstrap:themed Tasks
```

`bootstrap:install cdn` records the choice in `config/initializers/bootstrap.rb`,
so `bootstrap:layout` emits CDN tags by default afterwards. Pass `--cdn` or
`--no-cdn` to override it per run.

Both asset pipelines are supported. On **Sprockets**, `static` adds `require`
directives to your manifests. On **Propshaft** (the Rails 8 default) there are no
directives to add, so the generated layout links the vendored files directly —
run `rails g bootstrap:layout` after `bootstrap:install static` either way.

The Bootstrap version and its CDN URLs and integrity hashes live in one place,
`Twitter::Bootstrap::Rails::BOOTSTRAP_CDN`. No template hardcodes them.

## Snippets

Every snippet published at
[getbootstrap.com/docs/5.3/examples](https://getbootstrap.com/docs/5.3/examples/)
— 62 of them across 12 categories — is a command. Each writes an `.html.erb`
partial into `app/views/shared/`:

```bash
rails g bootstrap:header               # the first variant, "centered"
rails g bootstrap:header dark_search   # a specific variant
rails g bootstrap:header --list        # what's available, with descriptions
```

| Command | Variants |
|---|---|
| `rails g bootstrap:header` | `centered`, `nav_pills`, `with_auth_buttons`, `dark_search`, `light_search`, `grid_dropdown`, `double`, `dark_double` |
| `rails g bootstrap:hero` | `centered`, `centered_screenshot`, `with_image`, `signup_form`, `cropped_image`, `dark` |
| `rails g bootstrap:features` | `columns_with_icons`, `hanging_icons`, `custom_cards`, `icon_grid`, `with_title` |
| `rails g bootstrap:sidebar` | `dark`, `light`, `icon_only`, `collapsible`, `list_group` |
| `rails g bootstrap:footer` | `simple`, `with_brand`, `with_nav`, `columns`, `with_newsletter` |
| `rails g bootstrap:dropdown` | `simple`, `with_search`, `with_icons`, `calendar`, `mega_menu` |
| `rails g bootstrap:list_group` | `with_avatars`, `checkboxes`, `checkboxes_expanded`, `checkable`, `radios` |
| `rails g bootstrap:modal` | `sheet`, `confirm`, `whats_new`, `signup` |
| `rails g bootstrap:badge` | `pills`, `subtle`, `subtle_bordered`, `with_avatar`, `with_icons`, `with_avatar_divider` |
| `rails g bootstrap:breadcrumb` | `basic`, `with_icons`, `chevron`, `custom` |
| `rails g bootstrap:button` | `pills`, `grid`, `with_icons`, `loading`, `circle` |
| `rails g bootstrap:jumbotron` | `with_icon`, `placeholder`, `full_width`, `basic` |

Variants are listed in the order they appear on the docs page, so the first one
in each row is the first example Bootstrap shows.

Options, on every snippet command:

| Option | Effect |
|---|---|
| `--list` | Print the variants with descriptions and exit, writing nothing |
| `--as=NAME` | Partial name to write (default: the generator name) |
| `--path=DIR` | Where to write it (default: `app/views/shared`) |
| `--no-icons` | Skip installing the shared icon sprite |

```bash
rails g bootstrap:footer columns --as=site_footer --path=app/views/layouts
# -> app/views/layouts/_site_footer.html.erb
```

### Icons

36 of the 62 snippets use Bootstrap Icons through an SVG sprite. Those commands
also write `_bootstrap_icons.html.erb` next to the partial. Render it **once**,
near the top of `<body>` in your layout, or those icons come out as empty boxes:

```erb
<%= render "shared/bootstrap_icons" %>
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

Run `bootstrap:layout` even if you already have a layout — that step is what puts
Bootstrap's CSS and JS on the page.

## Upgrading to 5.4.0

5.4.0 is a breaking release:

- **Less is gone.** `rails g bootstrap:install less` no longer exists; the
  argument is now `static` (default) or `cdn`. Bootstrap 5 has no Less build, and
  the `less-rails` and `execjs` dependencies have been dropped.
- **Glyphicons are gone**, including the `glyph` helper. Bootstrap dropped them in
  v4. The snippet generators ship Bootstrap Icons instead.
- **CoffeeScript support is gone**, along with `--no-coffeescript`.
- The gem version no longer tracks the Bootstrap version.
  `Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION` says which Bootstrap ships.

If you are on Rails 8, note that `bootstrap:install static` previously left
Propshaft apps with no Bootstrap at all — that is fixed here. See the
[CHANGELOG](CHANGELOG.md) for the full list.

## Buy me a Coffee
## ☕ Support the Project

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=000000)](https://www.buymeacoffee.com/seyhunak)

## Contributors

Thanks to all contributors who are helping to make better.

<a href="https://github.com/seyhunak/twitter-bootstrap-rails/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=seyhunak/twitter-bootstrap-rails" />
</a>

### Star History

<a href="https://www.star-history.com/#seyhunak/twitter-bootstrap-rails&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=seyhunak/twitter-bootstrap-rails&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=seyhunak/twitter-bootstrap-rails&type=Date" />
   <img alt="Star history of seyhunak/twitter-bootstrap-rails over time" src="https://api.star-history.com/svg?repos=seyhunak/twitter-bootstrap-rails&type=Date" />
 </picture>
</a>


## License

MIT
