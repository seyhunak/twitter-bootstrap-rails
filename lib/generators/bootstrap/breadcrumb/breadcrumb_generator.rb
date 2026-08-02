require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Breadcrumbs from https://getbootstrap.com/docs/5.3/examples/breadcrumbs/
    class BreadcrumbGenerator < SnippetBase
      snippet_category "breadcrumbs"

      desc "Copies a Bootstrap breadcrumbs snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
