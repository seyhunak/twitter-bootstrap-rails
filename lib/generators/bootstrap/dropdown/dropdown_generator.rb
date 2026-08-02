require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Dropdowns from https://getbootstrap.com/docs/5.3/examples/dropdowns/
    class DropdownGenerator < SnippetBase
      snippet_category "dropdowns"

      desc "Copies a Bootstrap dropdowns snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
