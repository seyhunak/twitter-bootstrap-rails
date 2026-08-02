require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Modals from https://getbootstrap.com/docs/5.3/examples/modals/
    class ModalGenerator < SnippetBase
      snippet_category "modals"

      desc "Copies a Bootstrap modals snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
