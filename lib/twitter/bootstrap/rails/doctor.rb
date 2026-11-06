require 'twitter/bootstrap/rails/version'
require 'twitter/bootstrap/rails/config'
require 'twitter/bootstrap/rails/legacy_markup'

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

        def initialize(root)
          @root = root
        end

        def report
          checks = [css_check, js_check, version_check, sprite_check, placeholder_check, legacy_check]

          facts.merge(
            :status => checks.map { |c| c[:status] }.max_by { |s| SEVERITY.index(s) },
            :checks => checks,
            :legacy_markup => legacy_markup
          )
        end

        def facts
          {
            :bootstrap_version => BOOTSTRAP_VERSION,
            :gem_version => VERSION,
            :rails_version => ::Rails.version,
            :asset_pipeline => pipeline.to_s,
            :asset_mode => asset_mode,
            :template_engine => template_engine
          }
        end

        private

        def pipeline
          Twitter::Bootstrap::Rails.asset_pipeline
        end

        def asset_mode
          initializer = read("config/initializers/bootstrap.rb")
          cdn = initializer.match?(/asset_mode\s*=\s*:cdn/) || layouts.match?(%r{cdn\.jsdelivr\.net/npm/bootstrap@})
          cdn ? "cdn" : "static"
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
          found = layouts.scan(/bootstrap@(\d+\.\d+\.\d+)/).flatten
          [VENDORED_CSS, VENDORED_JS].each do |file|
            found.concat(read(file)[0, 400].to_s.scan(/Bootstrap\s+v(\d+\.\d+\.\d+)/).flatten)
          end
          stale = found.uniq - [BOOTSTRAP_VERSION]

          return check("bootstrap_version", "ok", "No Bootstrap version other than #{BOOTSTRAP_VERSION} found.") if stale.empty?

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
          count = legacy_markup.size
          return check("legacy_markup", "ok", "No older Bootstrap markup found.") if count.zero?

          check("legacy_markup", "warn", "#{count} use(s) of markup from older Bootstrap versions, listed in legacy_markup.",
                "Apply each replacement. Plain names like `close` or `well` may be your own CSS classes, so check before changing those.")
        end

        def legacy_markup
          @legacy_markup ||= scanned_files.flat_map do |file|
            LegacyMarkup.scan(read(file), File.extname(file)).map { |finding| { :file => file }.merge(finding) }
          end
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

        def relative_files(pattern)
          Dir[File.join(@root, pattern)]
            .select { |file| File.file?(file) && SCANNED_EXTENSIONS.include?(File.extname(file)) }
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
