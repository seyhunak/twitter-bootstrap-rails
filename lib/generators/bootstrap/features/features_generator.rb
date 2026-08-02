require 'generators/bootstrap/snippets/snippet_base'

module Bootstrap
  module Generators
    # Features from https://getbootstrap.com/docs/5.3/examples/features/
    class FeaturesGenerator < SnippetBase
      snippet_category "features"

      desc "Copies a Bootstrap features snippet into your views. " \
           "Run with --list to see the variants."
    end
  end
end
