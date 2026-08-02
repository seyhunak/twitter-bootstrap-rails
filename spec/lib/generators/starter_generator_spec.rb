require 'spec_helper'

describe Bootstrap::Generators::StarterGenerator do
  let(:cdn) { Twitter::Bootstrap::Rails::BOOTSTRAP_CDN }

  # The starter snippet exactly as published on
  # https://getbootstrap.com/docs/5.3/getting-started/introduction/
  let(:docs_snippet) do
    <<~HTML
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Bootstrap demo</title>
          <link href="#{cdn[:css][:url]}" rel="stylesheet" integrity="#{cdn[:css][:integrity]}" crossorigin="anonymous">
        </head>
        <body>
          <h1>Hello, world!</h1>
          <script src="#{cdn[:bundle][:url]}" integrity="#{cdn[:bundle][:integrity]}" crossorigin="anonymous"></script>
        </body>
      </html>
    HTML
  end

  it "reproduces the docs starter template byte for byte" do
    run_generator(described_class)

    expect(read_destination('public/bootstrap-starter.html')).to eq(docs_snippet)
  end

  it "honours --path" do
    run_generator(described_class, %w[--path=public/demo.html])

    expect(destination_exist?('public/demo.html')).to be true
    expect(destination_exist?('public/bootstrap-starter.html')).to be false
  end

  it "swaps in the Popper pair with --separate-popper" do
    run_generator(described_class, %w[--separate-popper])
    starter = read_destination('public/bootstrap-starter.html')

    expect(starter).to include(cdn[:popper][:url])
    expect(starter).to include(cdn[:js][:url])
    expect(starter).not_to include(cdn[:bundle][:url])
  end

  it "writes a standalone document with no ERB left in it" do
    run_generator(described_class)
    starter = read_destination('public/bootstrap-starter.html')

    expect(starter).not_to include("<%")
  end
end
