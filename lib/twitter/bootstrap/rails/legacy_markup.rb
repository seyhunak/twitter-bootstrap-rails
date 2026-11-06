module Twitter
  module Bootstrap
    module Rails
      # Finds Bootstrap 2-4 markup that does nothing on the Bootstrap 5 this gem
      # ships. bootstrap:doctor reports what it finds, bootstrap:agent turns the
      # same tables into guidance, and a spec holds the gem's own templates to it.
      module LegacyMarkup
        DATA_ATTRIBUTES = %w[toggle target dismiss ride slide slide-to parent spy].freeze

        CLASSES = {
          "btn-default" => "btn-secondary",
          "btn-xs" => "btn-sm",
          "btn-block" => "w-100",
          "navbar-default" => "bg-body-tertiary",
          "navbar-inverse" => "bg-dark with data-bs-theme=\"dark\"",
          "navbar-toggle" => "navbar-toggler",
          "navbar-header" => "nothing (remove the wrapper)",
          "navbar-left" => "me-auto",
          "navbar-right" => "ms-auto",
          "icon-bar" => "navbar-toggler-icon",
          "caret" => "nothing (dropdown-toggle draws it)",
          "divider" => "dropdown-divider on an hr",
          "dropdown-submenu" => "dropdown-header (Bootstrap 5 has no nested dropdowns)",
          "panel" => "card",
          "panel-default" => "card",
          "panel-heading" => "card-header",
          "panel-body" => "card-body",
          "panel-footer" => "card-footer",
          "well" => "card",
          "jumbotron" => "p-5 bg-body-tertiary rounded-3",
          "page-header" => "border-bottom pb-2 mb-4",
          "label" => "badge",
          "badge-pill" => "rounded-pill",
          "form-group" => "mb-3",
          "form-inline" => "row with col-auto columns",
          "form-horizontal" => "row with col-* columns",
          "control-group" => "mb-3",
          "control-label" => "form-label",
          "controls" => "nothing (remove the wrapper)",
          "has-error" => "is-invalid on the input",
          "help-block" => "form-text",
          "input-group-addon" => "input-group-text",
          "custom-select" => "form-select",
          "sr-only" => "visually-hidden",
          "close" => "btn-close",
          "in" => "show",
          "hidden" => "d-none",
          "pull-left" => "float-start",
          "pull-right" => "float-end",
          "float-left" => "float-start",
          "float-right" => "float-end",
          "text-left" => "text-start",
          "text-right" => "text-end",
          "font-weight-bold" => "fw-bold"
        }.freeze

        # [pattern, block turning the match into its replacement, example for docs]
        CLASS_PATTERNS = [
          [/\Acol-xs-(\d+)\z/, ->(m) { "col-#{m[1]}" }, "col-xs-6 becomes col-6"],
          [/\Aglyphicon(-[\w-]+)?\z/, ->(_) { "Bootstrap Icons" }, "glyphicon-* becomes Bootstrap Icons"],
          [/\A(?:label|badge)-(default|primary|secondary|success|info|warning|danger)\z/,
           ->(m) { "text-bg-#{m[1] == 'default' ? 'secondary' : m[1]}" }, "label-warning and badge-warning become text-bg-warning"],
          [/\A([mp])([lr])(-(?:sm|md|lg|xl|xxl))?-(\d|auto)\z/,
           ->(m) { "#{m[1]}#{m[2] == 'l' ? 's' : 'e'}#{m[3]}-#{m[4]}" }, "ml-3 and pr-md-2 become ms-3 and pe-md-2"]
        ].freeze

        DATA_ATTRIBUTE = /(?<![\w-])data-(#{DATA_ATTRIBUTES.join('|')})(?![\w-])/
        RUBY_DATA_HASH = /(?:\bdata:\s*|:data\s*=>\s*)\{([^}]*)\}/
        RUBY_DATA_KEY = /(?<![\w-]):?(#{DATA_ATTRIBUTES.join('|')})(?:\s*:|\s*=>)/
        CLASS_VALUE = /(?:\bclass\s*=\s*|\bclass:\s*|:class\s*=>\s*|["']class["']\s*=>\s*)(["'])(.*?)\1/
        EMBEDDED_CODE = /<%.*?%>|#\{.*?\}/
        SHORTHAND = {
          ".haml" => /\A\s*(?:%[\w:-]+)?(?:#[\w-]+)?((?:\.[\w-]+)+)/,
          ".slim" => /\A\s*(?:[a-z][\w:-]*)?(?:#[\w-]+)?((?:\.[\w-]+)+)/
        }.freeze

        module_function

        # Returns [{ :line, :found, :replacement }, ...] for a file's contents.
        # extension (".erb", ".haml", ...) decides whether to read class shorthand.
        def scan(text, extension)
          text.each_line.with_index(1).flat_map do |line, number|
            scan_line(line, extension).map { |found, replacement| { :line => number, :found => found, :replacement => replacement } }
          end
        end

        def scan_line(line, extension)
          data_attributes(line) + class_names(line, extension).filter_map do |name|
            replacement = replacement_for(name)
            [name, replacement] if replacement
          end
        end

        def data_attributes(line)
          names = line.scan(DATA_ATTRIBUTE).flatten
          line.scan(RUBY_DATA_HASH).flatten.each { |pairs| names.concat(pairs.scan(RUBY_DATA_KEY).flatten) }
          names.map { |name| ["data-#{name}", "data-bs-#{name}"] }
        end

        def class_names(line, extension)
          names = line.scan(CLASS_VALUE).flat_map { |_quote, value| value.gsub(EMBEDDED_CODE, " ").split }
          shorthand = SHORTHAND[extension] && line[SHORTHAND[extension], 1]
          names.concat(shorthand.split(".").reject(&:empty?)) if shorthand
          names
        end

        def replacement_for(name)
          return CLASSES[name] if CLASSES.key?(name)

          CLASS_PATTERNS.each do |pattern, replacement, _example|
            match = pattern.match(name)
            return replacement.call(match) if match
          end
          nil
        end
      end
    end
  end
end
