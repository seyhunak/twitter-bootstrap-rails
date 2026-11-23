require 'twitter/bootstrap/rails/config'
require 'twitter/bootstrap/rails/version'

module Bootstrap
  module Generators
    # For generators that write Bootstrap 5 markup. On an app running HeroDevs
    # Bootstrap NES 4.6 that markup doesn't work, so say so before writing it.
    module Bootstrap5Markup
      private

      def warn_if_nes
        return unless Twitter::Bootstrap::Rails.nes?

        say_status :warn,
          "This app runs Bootstrap #{Twitter::Bootstrap::Rails::BOOTSTRAP_NES[:bootstrap_version]} (NES), but this " \
          "generator writes Bootstrap 5 markup, which needs data-bs-* attributes and Bootstrap 5 classes. " \
          "Convert it to Bootstrap 4 markup, or migrate the app first.",
          :yellow
      end
    end
  end
end
