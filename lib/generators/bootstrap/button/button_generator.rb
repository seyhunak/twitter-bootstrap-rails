require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Buttons from https://getbootstrap.com/docs/5.3/examples/buttons/
    class ButtonGenerator < SnippetBase
      snippet_category "buttons"

      desc "Copies a Bootstrap buttons snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
