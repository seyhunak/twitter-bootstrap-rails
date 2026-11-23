require 'twitter/bootstrap/rails/legacy_markup'

module Twitter
  module Bootstrap
    module Rails
      # Finds Bootstrap 5 markup, Sass and JavaScript that changes in Bootstrap 6,
      # following the upstream migration skill
      # (npx skills add twbs/bootstrap --skill bootstrap-v5-v6-migration).
      # The gem still ships Bootstrap 5, so this is a worklist for an app that is
      # moving to 6, not markup to avoid today. `bootstrap:doctor --v6` reports it.
      module V6Migration
        SKILL_COMMAND = "npx skills add twbs/bootstrap --skill bootstrap-v5-v6-migration".freeze
        GUIDE_URL = "https://getbootstrap.com/docs/6.0/guides/migration/".freeze

        BREAKPOINTS = { "sm" => "sm", "md" => "md", "lg" => "lg", "xl" => "xl", "xxl" => "2xl" }.freeze
        THEMES = %w[primary secondary success danger warning info].freeze
        FONT_SIZES = { "1" => "4xl", "2" => "3xl", "3" => "2xl", "4" => "xl", "5" => "lg", "6" => "md" }.freeze
        RENAMED_COMPONENTS = { "modal" => "dialog", "offcanvas" => "drawer", "dropdown" => "menu" }.freeze
        # Classes that take a breakpoint as a suffix in v5 (navbar-expand-lg).
        SUFFIXED = %w[container navbar-expand offcanvas table-responsive list-group-horizontal vstack hstack col].freeze

        CLASSES = {
          "modal" => "dialog on a <dialog> element",
          "modal-dialog" => "nothing (remove the wrapper; use one <dialog class=\"dialog\">)",
          "modal-content" => "nothing (remove the wrapper; use one <dialog class=\"dialog\">)",
          "offcanvas" => "drawer on a <dialog> element",
          "dropdown" => "nothing (remove the wrapper; the toggle and .menu are siblings)",
          "dropdown-menu" => "menu",
          "dropdown-item" => "menu-item",
          "dropdown-divider" => "menu-divider",
          "dropdown-header" => "menu-header",
          "dropdown-toggle" => "nothing (the menu toggle needs no class)",
          "dropdown-toggle-split" => "nothing (remove it)",
          "text-muted" => "fg-secondary",
          "form-select" => "form-control (on the select)",
          "form-check" => "form-field",
          "form-check-input" => "check or radio (on the input)",
          "form-check-label" => "nothing (a plain label)",
          "form-switch" => "a switch wrapper around the input",
          "needs-validation" => "data-bs-validate on the form",
          "was-validated" => "nothing (:user-invalid handles it)",
          "has-validation" => "nothing (remove it)",
          "clearfix" => "d-flow-root",
          "lh-base" => "lh-md",
          "lead" => "fs-* and fw-* utilities",
          "placeholder-glow" => "placeholder-pulse (or placeholder-wave)",
          "btn-close-white" => "nothing (set the text colour instead)",
          "card-link" => "a plain link",
          "accordion-button" => "nothing (put the title in summary.accordion-header)",
          "accordion-collapse" => "nothing (use details.accordion-item)",
          "navbar-light" => "nothing (remove it)",
          "navbar-dark" => "nothing (use data-bs-theme=\"dark\")",
          "carousel-control-prev" => "btn-icon with data-bs-slide=\"prev\"",
          "carousel-control-next" => "btn-icon with data-bs-slide=\"next\"",
          "carousel-control-prev-icon" => "carousel-icon-prev",
          "carousel-control-next-icon" => "carousel-icon-next",
          "carousel-caption" => "your own markup",
          "carousel-dark" => "data-bs-theme=\"dark\""
        }.freeze

        # [pattern, block turning the match into its replacement, example for docs]
        CLASS_PATTERNS = [
          [/\Amodal-(header|body|footer|title|sm|lg|xl|fullscreen)\z/, ->(m) { "dialog-#{m[1]}" }, "modal-body becomes dialog-body"],
          [/\Aoffcanvas-(header|body|title|start|end|top|bottom)\z/, ->(m) { "drawer-#{m[1]}" }, "offcanvas-start becomes drawer-start"],
          [/\Adropdown-menu-(start|end)\z/, ->(m) { "menu-#{m[1]}" }, "dropdown-menu-end becomes menu-end"],
          [/\Amodal-fullscreen-(sm|md|lg|xl|xxl)-down\z/,
           ->(m) { "#{BREAKPOINTS[m[1]]}-down:dialog-fullscreen" }, "modal-fullscreen-sm-down becomes sm-down:dialog-fullscreen"],
          [/\A([a-z][\w-]*)-hover\z/,
           ->(m) { "hover:#{V6Migration.class_replacement(m[1])}" }, "opacity-50-hover becomes hover:opacity-50"],
          [/\Abtn-(outline-)?(#{THEMES.join('|')})\z/,
           ->(m) { "btn-#{m[1] ? 'outline' : 'solid'} theme-#{m[2]}" }, "btn-primary and btn-outline-primary become btn-solid theme-primary and btn-outline theme-primary"],
          [/\Aalert-(#{THEMES.join('|')})\z/, ->(m) { "alert theme-#{m[1]}" }, "alert-info becomes alert theme-info"],
          [/\Atext-bg-(#{THEMES.join('|')})\z/, ->(m) { "bg-#{m[1]} fg-contrast-#{m[1]}" }, "text-bg-warning becomes bg-warning fg-contrast-warning"],
          [/\Atext-(#{THEMES.join('|')})\z/, ->(m) { "fg-#{m[1]}" }, "text-danger becomes fg-danger"],
          [/\A(?:btn|btn-outline|alert|text|text-bg)-(light|dark)\z/,
           ->(_) { "a neutral surface, a colour mode or theme-inverse (v6 has no theme-light or theme-dark)" },
           "btn-light and text-dark become a neutral surface, a colour mode or theme-inverse"],
          [/\Afs-([1-6])\z/, ->(m) { "fs-#{FONT_SIZES[m[1]]}" }, "fs-1 and fs-6 become fs-4xl and fs-md"],
          [/\Adisplay-[1-6]\z/, ->(_) { "fs-* and fw-* utilities" }, "display-1 becomes fs-* and fw-* utilities"],
          [/\Am(h|w)-(.+)\z/, ->(m) { "max-#{m[1]}-#{m[2]}" }, "mw-100 becomes max-w-100"],
          [/\Alink-(offset|underline)(-.+)?\z/,
           ->(m) { "underline#{m[1] == 'offset' ? '-offset' : ''}#{m[2]}" }, "link-offset-2 becomes underline-offset-2"],
          [/\Am[tbsexy]?-n\d\z/, ->(_) { "ms--1, ms--2, me--1, me--2 or your own style" }, "mt-n1 becomes ms--1 / me--1 or your own style"],
          [/\A(#{SUFFIXED.join('|')})-(sm|md|lg|xl|xxl)\z/,
           ->(m) { "#{BREAKPOINTS[m[2]]}:#{V6Migration.class_replacement(m[1])}" }, "navbar-expand-lg becomes lg:navbar-expand"],
          [/\A([a-z][\w-]*?)-print-([\w-]+)\z/,
           ->(m) { "print:#{V6Migration.class_replacement("#{m[1]}-#{m[2]}")}" }, "d-print-none becomes print:d-none"],
          [/\A([a-z][\w-]*?)-(sm|md|lg|xl|xxl)-([\w-]+)\z/,
           ->(m) { "#{BREAKPOINTS[m[2]]}:#{V6Migration.class_replacement("#{m[1]}-#{m[3]}")}" },
           "col-md-6 and d-xxl-none become md:col-6 and 2xl:d-none"]
        ].freeze

        TOGGLE = /(?:data-bs-|\bbs[_-])(toggle|dismiss)["']?\s*(?:=>|=|:)\s*(["'])(#{RENAMED_COMPONENTS.keys.join('|')})\2/

        # [pattern, replacement, example for docs]. Applied to every scanned file.
        LINE_PATTERNS = [
          [/(?:data-bs-|\bbs[_-])ride(?![\w-])/, %{data-bs-autoplay="true" (carousels no longer start on their own)}],
          [/@import\s+(["'])bootstrap/, %{@use "bootstrap/scss/bootstrap" (add `as *` to keep v5 names)}],
          [/\bbootstrap\.(?:Modal|Offcanvas|Dropdown)\b/, "import { Dialog, Drawer, Menu } from Bootstrap's module build"],
          [/\bpopperConfig\b/, "floatingConfig"],
          [/@popperjs\/core/, "@floating-ui/dom"],
          [/--bs-[\w-]+-rgb\b/, "color-mix(in oklab, var(--bs-…), transparent N%)"]
        ].freeze

        # Files whose class attributes and shorthand are read for class names.
        MARKUP_EXTENSIONS = %w[.erb .haml .slim .rb .html].freeze

        module_function

        # Returns [{ :line, :found, :replacement }, ...] for a file's contents.
        def scan(text, extension)
          text.each_line.with_index(1).flat_map do |line, number|
            scan_line(line, extension).map { |found, replacement| { :line => number, :found => found, :replacement => replacement } }
          end
        end

        def scan_line(line, extension)
          classes = MARKUP_EXTENSIONS.include?(extension) ? LegacyMarkup.class_names(line, extension) : []
          renamed = classes.filter_map do |name|
            replacement = replacement_for(name)
            [name, replacement] if replacement
          end

          toggles = line.scan(TOGGLE).map do |attribute, _quote, value|
            [%{data-bs-#{attribute}="#{value}"}, %{data-bs-#{attribute}="#{RENAMED_COMPONENTS[value]}"}]
          end

          other = LINE_PATTERNS.flat_map do |pattern, replacement|
            matches = []
            line.scan(pattern) { matches << [Regexp.last_match(0).sub(/\Abs[_-]/, "data-bs-"), replacement] }
            matches
          end

          renamed + toggles + other
        end

        def replacement_for(name)
          return CLASSES[name] if CLASSES.key?(name)

          CLASS_PATTERNS.each do |pattern, replacement, _example|
            match = pattern.match(name)
            return replacement.call(match) if match
          end
          nil
        end

        # The v6 name for a class when it is a plain rename, otherwise the class itself.
        # Used under a breakpoint prefix, where a sentence would make no sense.
        def class_replacement(name)
          replacement = RENAMED_COMPONENTS[name] || replacement_for(name)
          replacement && replacement.match?(/\A[\w:-]+\z/) ? replacement : name
        end
      end
    end
  end
end
