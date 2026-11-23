require 'spec_helper'

describe Bootstrap::Generators::CdnGenerator do
  let(:cdn) { Twitter::Bootstrap::Rails::BOOTSTRAP_CDN }

  it "prints the stylesheet link and the JS bundle by default" do
    output = run_generator(described_class)

    expect(output).to include(cdn[:css][:url])
    expect(output).to include(cdn[:css][:integrity])
    expect(output).to include(cdn[:bundle][:url])
    expect(output).to include(cdn[:bundle][:integrity])
  end

  it "prints only the stylesheet link with --css" do
    output = run_generator(described_class, %w[--css])

    expect(output).to include(cdn[:css][:url])
    expect(output).not_to include(cdn[:bundle][:url])
  end

  it "prints only the bundle script with --js" do
    output = run_generator(described_class, %w[--js])

    expect(output).to include(cdn[:bundle][:url])
    expect(output).not_to include(cdn[:css][:url])
  end

  it "prints the Popper pair with --separate-popper" do
    output = run_generator(described_class, %w[--separate-popper])

    expect(output).to include(cdn[:popper][:url])
    expect(output).to include(cdn[:js][:url])
    expect(output).not_to include(cdn[:bundle][:url])
  end

  it "writes nothing to disk" do
    run_generator(described_class)

    expect(Dir.children(destination_root)).to be_empty
  end
  describe "--bootstrap=6" do
    let(:next_cdn) { Twitter::Bootstrap::Rails::BOOTSTRAP_NEXT_CDN }

    it "prints the Bootstrap 6 prerelease tags, with the bundle as an ES module" do
      output = run_generator(described_class, %w[--bootstrap=6])

      expect(output).to include(next_cdn[:css][:url], next_cdn[:css][:integrity])
      expect(output).to include(%{<script type="module" src="#{next_cdn[:bundle][:url]}" integrity="#{next_cdn[:bundle][:integrity]}"})
      expect(output).not_to include(cdn[:css][:url])
    end

    it "warns that it is a prerelease the gem's markup does not match" do
      output = run_generator(described_class, %w[--bootstrap=6])

      expect(output).to include(Twitter::Bootstrap::Rails::BOOTSTRAP_NEXT_VERSION).and include("bootstrap:doctor --v6")
    end

    it "points at Bootstrap 6 files" do
      expect(next_cdn.values.map { |entry| entry[:url] }).to all(include("bootstrap@#{Twitter::Bootstrap::Rails::BOOTSTRAP_NEXT_VERSION}/"))
    end

    it "has no separate Popper pair" do
      expect { run_generator(described_class, %w[--bootstrap=6 --separate-popper]) }
        .to raise_error(Rails::Generators::Error, /separate-popper/)
    end

    it "rejects other versions" do
      expect { run_generator(described_class, %w[--bootstrap=4]) }
        .to raise_error(Rails::Generators::Error, /bootstrap:nes/)
    end
  end
end
