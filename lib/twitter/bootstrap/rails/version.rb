module Twitter
  module Bootstrap
    module Rails
      VERSION = "5.4.0"

      # The Bootstrap release this gem vendors and links to. The gem version no
      # longer tracks it; this constant is the authoritative statement.
      BOOTSTRAP_VERSION = "5.3.8"
      POPPER_VERSION = "2.11.8"

      # URLs and Subresource Integrity hashes exactly as published on
      # https://getbootstrap.com/docs/5.3/getting-started/introduction/
      # Bumping Bootstrap means editing this hash and re-vendoring the dist files.
      BOOTSTRAP_CDN = {
        :css => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_VERSION}/dist/css/bootstrap.min.css",
          :integrity => "sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
        },
        :bundle => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_VERSION}/dist/js/bootstrap.bundle.min.js",
          :integrity => "sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        },
        :js => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_VERSION}/dist/js/bootstrap.min.js",
          :integrity => "sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y"
        },
        :popper => {
          :url => "https://cdn.jsdelivr.net/npm/@popperjs/core@#{POPPER_VERSION}/dist/umd/popper.min.js",
          :integrity => "sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
        }
      }.freeze
    end
  end
end
