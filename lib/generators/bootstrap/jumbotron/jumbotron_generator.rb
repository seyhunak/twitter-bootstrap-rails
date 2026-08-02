require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Jumbotrons from https://getbootstrap.com/docs/5.3/examples/jumbotrons/
    class JumbotronGenerator < SnippetBase
      snippet_category "jumbotrons"

      desc "Copies a Bootstrap jumbotrons snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
