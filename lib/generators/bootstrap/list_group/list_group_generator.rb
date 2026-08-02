require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # List groups from https://getbootstrap.com/docs/5.3/examples/list-groups/
    class ListGroupGenerator < SnippetBase
      snippet_category "list-groups"

      desc "Copies a Bootstrap list groups snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
