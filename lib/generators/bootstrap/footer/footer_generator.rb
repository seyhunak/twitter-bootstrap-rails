require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Footers from https://getbootstrap.com/docs/5.3/examples/footers/
    class FooterGenerator < SnippetBase
      snippet_category "footers"

      desc "Copies a Bootstrap footers snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
