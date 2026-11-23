require 'json'
require 'twitter/bootstrap/rails/version'
require 'twitter/bootstrap/rails/config'
require 'twitter/bootstrap/rails/legacy_markup'
require 'twitter/bootstrap/rails/v6_migration'

module Twitter
  module Bootstrap
    module Rails
      # Inspects a host app and reports how Bootstrap is set up. Reads files only.
      # Every check is { :id, :status, :message } plus :fix when there is one, and
      # status is "ok", "warn" or "error".
      class Doctor
        VENDORED_CSS = "app/assets/stylesheets/twitter/bootstrap/bootstrap.min.css".freeze
        VENDORED_JS = "app/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js".freeze
        SCANNED_EXTENSIONS = %w[.erb .haml .slim .rb].freeze
        PLACEHOLDER_IMAGES = ["bootstrap-docs.png", "bootstrap-themes.png", "/docs/5.3/assets/", "unsplash-photo-"].freeze
        SEVERITY = %w[ok warn error].freeze
        IMPORTMAP = "config/importmap.rb".freeze
        APPLICATION_JS = "app/javascript/application.js".freeze
        # What `--v6` scans on top of views and helpers. The gem's own vendored
        # Bootstrap files are skipped: replacing them is the first migration step.
        V6_EXTRA_FILES = "app/{javascript,assets/javascripts,assets/stylesheets}/**/*".freeze
        V6_EXTENSIONS = %w[.js .mjs .ts .css .scss .sass].freeze
        VENDORED_DIR = %r{/twitter/bootstrap/}

        def initialize(root)
          @root = root
        end

        # v6: true adds a v6_migration check and list for apps moving to Bootstrap 6.
        def report(v6: false)
          checks = if nes?
                     [nes_package_check, nes_registry_check, importmap_tags_check]
                   else
                     [css_check, js_check, importmap_tags_check, version_check]
                   end
          checks += [sprite_check, placeholder_check, legacy_check]
          checks << v6_check if v6

          result = facts.merge(
            :status => checks.map { |c| c[:status] }.max_by { |s| SEVERITY.index(s) },
            :checks => checks,
            :legacy_markup => legacy_markup
          )
          v6 ? result.merge(:v6_migration => v6_migration) : result
        end

        def facts
          {
            :bootstrap_version => nes? ? BOOTSTRAP_NES[:bootstrap_version] : BOOTSTRAP_VERSION,
            :bootstrap_distribution => nes? ? BOOTSTRAP_NES[:name] : "Bootstrap",
            :gem_version => VERSION,
            :rails_version => ::Rails.version,
            :asset_pipeline => pipeline.to_s,
            :asset_mode => asset_mode,
            :template_engine => template_engine
          }
        end

        private

        def nes?
          asset_mode == "nes"
        end

        def pipeline
          Twitter::Bootstrap::Rails.asset_pipeline
        end

        def asset_mode
          @asset_mode ||= begin
            recorded = read("config/initializers/bootstrap.rb")[/asset_mode\s*=\s*:(\w+)/, 1]
            recorded || (layouts.match?(%r{cdn\.jsdelivr\.net/npm/bootstrap@}) ? "cdn" : "static")
          end
        end

        def template_engine
          app = ::Rails.application
          (app && app.config.generators.options.dig(:rails, :template_engine) || :erb).to_s
        end

        def css_check
          asset_check("bootstrap_css", "stylesheet",
                      :cdn => %r{bootstrap@[\d.]+/dist/css/bootstrap},
                      :vendored_name => "twitter/bootstrap/bootstrap.min",
                      :vendored_file => VENDORED_CSS,
                      :manifest => "app/assets/stylesheets/application.css",
                      :manifest_entry => %r{bootstrap_and_overrides|twitter/bootstrap|require_tree},
                      :layout_tag => /stylesheet_link_tag[^\n]*application/)
        end

        def js_check
          return importmap_js_check if asset_mode == "importmap"

          asset_check("bootstrap_js", "JavaScript",
                      :cdn => %r{bootstrap@[\d.]+/dist/js/bootstrap},
                      :vendored_name => "twitter/bootstrap/bootstrap.bundle.min",
                      :vendored_file => VENDORED_JS,
                      :manifest => "app/assets/javascripts/application.js",
                      :manifest_entry => %r{twitter/bootstrap|require_tree},
                      :layout_tag => /javascript_include_tag[^\n]*application/)
        end

        def asset_check(id, label, source)
          return check(id, "ok", "Bootstrap #{label} is linked from the CDN.") if layouts.match?(source[:cdn])

          if linked_through_pipeline?(source)
            return check(id, "ok", "Bootstrap #{label} is linked from the asset pipeline.") if exist?(source[:vendored_file])

            return check(id, "error", "A layout links the Bootstrap #{label}, but #{source[:vendored_file]} does not exist.",
                         "Run `rails g bootstrap:install static`.")
          end

          if bundled_elsewhere?
            return check(id, "warn", "Bootstrap appears to come from package.json or the importmap, so the #{label} can't be verified.")
          end

          check(id, "error", "No layout loads the Bootstrap #{label}, so the page will render unstyled or without behaviour.",
                "Run `rails g bootstrap:install static` (or `cdn`), then `rails g bootstrap:layout`, " \
                "or link it from your own layout (`rails g bootstrap:cdn` prints the tags).")
        end

        def importmap_js_check
          pinned = read(IMPORTMAP).match?(/^\s*pin\s+["']bootstrap["']/)
          unless pinned
            return check("bootstrap_js", "error", "#{IMPORTMAP} does not pin \"bootstrap\", so `import \"bootstrap\"` fails in the browser.",
                         "Run `rails g bootstrap:install importmap`.")
          end

          vendored = read(IMPORTMAP)[/^\s*pin\s+["']bootstrap["']\s*,\s*to:\s*["']([^"']+)["']/, 1]
          if vendored && !vendored.start_with?("http") && !exist?(File.join("vendor/javascript", vendored))
            return check("bootstrap_js", "error", "#{IMPORTMAP} pins bootstrap to vendor/javascript/#{vendored}, which does not exist.",
                         "Run `rails g bootstrap:install importmap`.")
          end

          unless javascript_sources.match?(/^\s*import\s+(?:\*\s+as\s+\w+\s+from\s+|\{[^}]*\}\s+from\s+)?["']bootstrap["']/)
            return check("bootstrap_js", "error", "Bootstrap is pinned, but nothing in app/javascript imports it, so it never runs.",
                         "Add `import \"bootstrap\"` to #{APPLICATION_JS}.")
          end

          check("bootstrap_js", "ok", "Bootstrap JavaScript is pinned in the importmap and imported.")
        end

        def nes_package_check
          json = package_json
          spec = json.dig("dependencies", "bootstrap").to_s
          prefix = "npm:#{BOOTSTRAP_NES[:package]}@"

          unless spec.start_with?(prefix)
            return check("nes_package", "error",
                         "This app is set to NES mode, but package.json's bootstrap dependency is #{spec.empty? ? 'missing' : spec.inspect}, not the NES package.",
                         "Run `rails g bootstrap:nes`.")
          end

          version = spec.delete_prefix(prefix)
          if version != BOOTSTRAP_NES[:version]
            return check("nes_package", "warn",
                         "package.json uses #{BOOTSTRAP_NES[:name]} #{version}; the latest this gem knows is #{BOOTSTRAP_NES[:version]}.",
                         "Run `rails g bootstrap:nes`, then `npm install`.")
          end

          unless json.dig("overrides", "bootstrap")
            return check("nes_package", "warn", "package.json has no override for bootstrap, so a dependency could still pull in an unpatched Bootstrap.",
                         "Run `rails g bootstrap:nes`.")
          end

          check("nes_package", "ok", "package.json uses #{BOOTSTRAP_NES[:name]} #{version}, with an override.")
        end

        def nes_registry_check
          npmrc = read(".npmrc")
          registry = BOOTSTRAP_NES[:registry]
          unless npmrc.include?("@neverendingsupport:registry=#{registry}")
            return check("nes_registry", "error", ".npmrc doesn't point @neverendingsupport at #{registry}, so npm can't find the NES package.",
                         "Run `rails g bootstrap:nes`.")
          end

          auth = npmrc[/^#{Regexp.escape(registry.sub(/\Ahttps?:/, ''))}:_authToken=(.*)$/, 1]
          if auth.nil?
            return check("nes_registry", "error", ".npmrc has no access token line for the NES registry.",
                         "Run `rails g bootstrap:nes`, then export #{BOOTSTRAP_NES[:token_env]}.")
          end

          unless auth.strip.match?(/\A\$\{\w+\}\z/)
            # Never echo the value: it is a credential.
            return check("nes_registry", "warn", ".npmrc contains the NES access token itself, which leaks it if the file is committed.",
                         "Replace it with ${#{BOOTSTRAP_NES[:token_env]}} and set that environment variable instead.")
          end

          check("nes_registry", "ok", ".npmrc reads the NES access token from #{auth.strip}.")
        end

        def package_json
          JSON.parse(read("package.json"))
        rescue JSON::ParserError
          {}
        end

        def importmap_tags_check
          return check("importmap_tags", "ok", "The app does not use importmap.") unless exist?(IMPORTMAP)
          return check("importmap_tags", "ok", "A layout loads the importmap.") if layouts.include?("javascript_importmap_tags")

          check("importmap_tags", "warn",
                "#{IMPORTMAP} exists, but no layout calls javascript_importmap_tags, so the app's own JavaScript " \
                "(Turbo, Stimulus, an imported Bootstrap) never loads.",
                "Add <%= javascript_importmap_tags %> to the <head> of your layout, or re-run `rails g bootstrap:layout`.")
        end

        def javascript_sources
          relative_files("app/javascript/**/*", %w[.js .mjs]).map { |file| read(file) }.join("\n")
        end

        def linked_through_pipeline?(source)
          propshaft_link = layouts.include?(source[:vendored_name])
          sprockets_link = layouts.match?(source[:layout_tag]) && read(source[:manifest]).match?(source[:manifest_entry])

          case pipeline
          when :propshaft then propshaft_link
          when :sprockets then sprockets_link
          else propshaft_link || sprockets_link
          end
        end

        def bundled_elsewhere?
          read("package.json").match?(/"bootstrap"\s*:/) || read("config/importmap.rb").match?(/pin\s+["']bootstrap["']/)
        end

        def version_check
          found = layouts.scan(/bootstrap@(\d+\.\d+\.\d+(?:-[\w.]+)?)/).flatten
          [VENDORED_CSS, VENDORED_JS].each do |file|
            found.concat(read(file)[0, 400].to_s.scan(/Bootstrap\s+v(\d+\.\d+\.\d+)/).flatten)
          end
          stale = found.uniq - [BOOTSTRAP_VERSION]

          return check("bootstrap_version", "ok", "No Bootstrap version other than #{BOOTSTRAP_VERSION} found.") if stale.empty?

          if stale.any? { |version| version.start_with?("6.") }
            return check("bootstrap_version", "warn",
                         "Found Bootstrap #{stale.join(', ')}. This gem ships #{BOOTSTRAP_VERSION}, and its generators and helpers write Bootstrap 5 markup.",
                         "Run `rails g bootstrap:doctor --v6` for the Bootstrap 5 markup to migrate.")
          end

          check("bootstrap_version", "warn",
                "Found Bootstrap #{stale.join(', ')}, but this gem ships #{BOOTSTRAP_VERSION}.",
                "Run `rails g bootstrap:install static --force` or update the CDN tags with `rails g bootstrap:cdn`.")
        end

        def sprite_check
          sprite = view_files.find { |file| File.basename(file) == "_bootstrap_icons.html.erb" }
          return check("icon_sprite", "ok", "The icon sprite is not installed.") unless sprite

          renders = view_files.sum { |file| read(file).scan(/render\b[^\n]*bootstrap_icons/).size }
          case renders
          when 0
            render_path = sprite.sub(%r{\Aapp/views/}, "").sub("_bootstrap_icons.html.erb", "bootstrap_icons")
            check("icon_sprite", "error", "The icon sprite is installed but never rendered, so snippet icons come out empty.",
                  %{Add <%= render "#{render_path}" %> once, near the top of <body> in your layout.})
          when 1
            check("icon_sprite", "ok", "The icon sprite is rendered once.")
          else
            check("icon_sprite", "warn", "The icon sprite is rendered #{renders} times, which repeats its symbol ids.",
                  "Render it once, in your layout.")
          end
        end

        def placeholder_check
          files = view_files.flat_map do |file|
            read(file).each_line.with_index(1).filter_map do |line, number|
              "#{file}:#{number}" if PLACEHOLDER_IMAGES.any? { |image| line.include?(image) }
            end
          end
          return check("placeholder_images", "ok", "No docs-site placeholder images found.") if files.empty?

          check("placeholder_images", "warn", "#{files.size} reference(s) to placeholder images that only exist on the Bootstrap docs site.",
                "Point them at your own images.").merge(:files => files)
        end

        def legacy_check
          if nes?
            return check("legacy_markup", "ok",
                         "Skipped: this app runs Bootstrap #{BOOTSTRAP_NES[:bootstrap_version]} (NES), where Bootstrap 4 markup is correct.")
          end

          count = legacy_markup.size
          return check("legacy_markup", "ok", "No older Bootstrap markup found.") if count.zero?

          check("legacy_markup", "warn", "#{count} use(s) of markup from older Bootstrap versions, listed in legacy_markup.",
                "Apply each replacement. Plain names like `close` or `well` may be your own CSS classes, so check before changing those.")
        end

        def legacy_markup
          return [] if nes?

          @legacy_markup ||= scanned_files.flat_map do |file|
            LegacyMarkup.scan(read(file), File.extname(file)).map { |finding| { :file => file }.merge(finding) }
          end
        end

        def v6_check
          count = v6_migration.size
          return check("v6_migration", "ok", "Nothing found that changes in Bootstrap 6.") if count.zero?

          check("v6_migration", "warn",
                "#{count} use(s) of Bootstrap 5 markup, Sass or JavaScript that change in Bootstrap 6, listed in v6_migration. " \
                "This gem still ships Bootstrap #{BOOTSTRAP_VERSION}, so only change them as part of moving the app to Bootstrap 6.",
                "Install the upstream migration skill (`#{V6Migration::SKILL_COMMAND}`) and follow it, " \
                "or read #{V6Migration::GUIDE_URL}. Switch the Bootstrap assets first.")
        end

        def v6_migration
          @v6_migration ||= v6_files.flat_map do |file|
            V6Migration.scan(read(file), File.extname(file)).map { |finding| { :file => file }.merge(finding) }
          end
        end

        def v6_files
          extra = relative_files(V6_EXTRA_FILES, V6_EXTENSIONS).reject { |file| file.match?(VENDORED_DIR) }
          (scanned_files + extra).uniq.sort
        end

        def check(id, status, message, fix = nil)
          result = { :id => id, :status => status, :message => message }
          result[:fix] = fix if fix
          result
        end

        def layouts
          @layouts ||= view_files.select { |file| file.start_with?("app/views/layouts/") }.map { |file| read(file) }.join("\n")
        end

        def view_files
          @view_files ||= relative_files("app/views/**/*").reject { |file| file.end_with?(".rb") }
        end

        def scanned_files
          relative_files("app/{views,helpers,components}/**/*")
        end

        def relative_files(pattern, extensions = SCANNED_EXTENSIONS)
          Dir[File.join(@root, pattern)]
            .select { |file| File.file?(file) && extensions.include?(File.extname(file)) }
            .map { |file| file.delete_prefix("#{@root}/") }
            .sort
        end

        def exist?(relative)
          File.file?(File.join(@root, relative))
        end

        def read(relative)
          exist?(relative) ? File.read(File.join(@root, relative)).scrub : ""
        end
      end
    end
  end
end
