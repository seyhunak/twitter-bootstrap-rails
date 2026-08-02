require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Badges from https://getbootstrap.com/docs/5.3/examples/badges/
    class BadgeGenerator < SnippetBase
      snippet_category "badges"

      desc "Copies a Bootstrap badges snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
