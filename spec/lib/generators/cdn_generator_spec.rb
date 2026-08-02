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
end
