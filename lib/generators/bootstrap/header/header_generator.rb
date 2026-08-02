require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Headers from https://getbootstrap.com/docs/5.3/examples/headers/
    class HeaderGenerator < SnippetBase
      snippet_category "headers"

      desc "Copies a Bootstrap headers snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
