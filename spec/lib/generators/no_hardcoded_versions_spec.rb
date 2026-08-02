require 'spec_helper'

# Bumping Bootstrap should be a one-file change. If a template hardcodes a CDN
# URL or an integrity hash, that promise quietly breaks.
describe "generator templates" do
  gem_root = File.expand_path("../../../..", __FILE__)

  let(:template_files) do
    Dir[File.join(gem_root, "lib/generators/**/templates/**/*")].select { |f| File.file?(f) }
  end

  it "has templates to check" do
    expect(template_files).not_to be_empty
  end

  it "hardcodes no Bootstrap CDN version" do
    offenders = template_files.select { |f| File.read(f).include?("bootstrap@") }

    expect(offenders).to be_empty,
      "these templates hardcode a CDN version instead of using the constants: #{offenders.inspect}"
  end

  it "hardcodes no Subresource Integrity hash" do
    offenders = template_files.select { |f| File.read(f).match?(/sha384-/) }

    expect(offenders).to be_empty,
      "these templates hardcode an integrity hash instead of using the constants: #{offenders.inspect}"
  end

  it "keeps the vendored assets on the version the gem declares" do
    version = Twitter::Bootstrap::Rails::BOOTSTRAP_VERSION

    {
      "vendor/assets/stylesheets/twitter/bootstrap/bootstrap.min.css" => "Bootstrap  v#{version}",
      "vendor/assets/javascripts/twitter/bootstrap/bootstrap.bundle.min.js" => "Bootstrap v#{version}",
      "app/assets/stylesheets/twitter-bootstrap-static/bootstrap.css" => "Bootstrap  v#{version}",
      "app/assets/javascripts/twitter/bootstrap/bootstrap.min.js" => "Bootstrap v#{version}"
    }.each do |path, banner|
      full = File.join(gem_root, path)
      expect(File.exist?(full)).to be(true), "missing vendored asset #{path}"
      expect(File.read(full, 400)).to include(banner),
        "#{path} is not Bootstrap #{version}"
    end
  end
end
