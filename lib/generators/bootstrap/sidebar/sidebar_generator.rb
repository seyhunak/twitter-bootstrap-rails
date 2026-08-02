require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Sidebars from https://getbootstrap.com/docs/5.3/examples/sidebars/
    class SidebarGenerator < SnippetBase
      snippet_category "sidebars"

      desc "Copies a Bootstrap sidebars snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
