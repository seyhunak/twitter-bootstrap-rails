require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Heroes from https://getbootstrap.com/docs/5.3/examples/heroes/
    class HeroGenerator < SnippetBase
      snippet_category "heroes"

      desc "Copies a Bootstrap heroes snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
