module Twitter
  module Bootstrap
    module Rails
      VERSION = "5.6.0"

      # The Bootstrap release this gem vendors and links to. The gem version no
      # longer tracks it; this constant is the authoritative statement.
      BOOTSTRAP_VERSION = "5.3.9"
      POPPER_VERSION = "2.11.8"

      # URLs and Subresource Integrity hashes exactly as published on
      # https://getbootstrap.com/docs/5.3/getting-started/introduction/
      # Bumping Bootstrap means editing this hash and re-vendoring the dist files.
      BOOTSTRAP_CDN = {
        :css => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_VERSION}/dist/css/bootstrap.min.css",
          :integrity => "sha384-yEPZ7jP9S0QKiUQ0m3jjsO4ProIW7wvR9gXkI7JOGa2XVsw53Yke2bsdkBbjmmiX"
        },
        :bundle => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_VERSION}/dist/js/bootstrap.bundle.min.js",
          :integrity => "sha384-WyOxWvTyr1QaMPfiPJSv76iReVthorl5uWlFtZPyK0IEB0hGzo9y5Bp9mYanr8Bu"
        },
        :js => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_VERSION}/dist/js/bootstrap.min.js",
          :integrity => "sha384-89aa4glufciPv46aKltztWQEmk+Tu9W2RhzXr6VcnUUEub7F8+06RcL2RYLCOHUq"
        },
        :popper => {
          :url => "https://cdn.jsdelivr.net/npm/@popperjs/core@#{POPPER_VERSION}/dist/umd/popper.min.js",
          :integrity => "sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
        }
      }.freeze

      # The Bootstrap 6 prerelease that `rails g bootstrap:cdn --bootstrap=6` prints.
      # The gem's generators and helpers still write Bootstrap 5 markup, so this is
      # only for trying 6 out or migrating to it. Its bundle is an ES module and
      # includes Floating UI, so there is no separate Popper pair. The integrity
      # hashes are sha384 of the files jsDelivr serves for this version.
      BOOTSTRAP_NEXT_VERSION = "6.0.0-alpha.1"
      BOOTSTRAP_NEXT_CDN = {
        :css => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_NEXT_VERSION}/dist/css/bootstrap.min.css",
          :integrity => "sha384-B/GM4XqrwHnWXNOWMbloTmrYXZg10cakYGmpfsR/bbzQ6JAJI4ihuyADKLnBgrCe"
        },
        :bundle => {
          :url => "https://cdn.jsdelivr.net/npm/bootstrap@#{BOOTSTRAP_NEXT_VERSION}/dist/js/bootstrap.bundle.min.js",
          :integrity => "sha384-1a/pXj49ZQ1aHEmrJ+gMw1otqoVsYwlEnlD8mIfY2TV03r20Y0CN7uqx1tQogjPL"
        }
      }.freeze

      # HeroDevs Bootstrap NES (Never-Ending Support): security-patched Bootstrap 4.6
      # for apps that can't move to 5 yet. It is a paid product served only from
      # HeroDevs' private npm registry, so the gem can't vendor it; `rails g
      # bootstrap:nes` points an app's package.json and .npmrc at it instead.
      # Source: https://docs.herodevs.com/bootstrap/bootstrap-4-6 and its release notes.
      BOOTSTRAP_NES = {
        :name => "HeroDevs Bootstrap NES",
        :package => "@neverendingsupport/bootstrap",
        :version => "4.6.2-bootstrap-4.6.5",
        :bootstrap_version => "4.6.5",
        :registry => "https://registry.nes.herodevs.com/npm/pkg/",
        :token_env => "HERODEVS_NES_TOKEN",
        :docs => "https://docs.herodevs.com/bootstrap/bootstrap-4-6"
      }.freeze
    end
  end
end
