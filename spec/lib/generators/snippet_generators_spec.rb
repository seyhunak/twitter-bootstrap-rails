require 'spec_helper'

describe "Bootstrap snippet generators" do
  Catalog = Bootstrap::Generators::SnippetCatalog
  TEMPLATE_ROOT = File.expand_path("../../../../lib/generators/bootstrap/snippets/templates", __FILE__)

  def generator_for(name)
    Bootstrap::Generators.const_get("#{name.split('_').map(&:capitalize).join}Generator")
  end

  describe "the catalog" do
    it "covers all twelve snippet categories from the docs" do
      expect(Catalog::GENERATORS.values.sort).to eq(%w[
        badges breadcrumbs buttons dropdowns features footers headers heroes
        jumbotrons list-groups modals sidebars
      ].sort)
    end

    it "has a template file for every catalogued variant" do
      missing = Catalog::VARIANTS.flat_map do |category, variants|
        variants.map { |v| "#{category}/#{v[:name]}" }
               .reject { |rel| File.exist?(File.join(TEMPLATE_ROOT, "#{rel}.html.erb")) }
      end

      expect(missing).to be_empty, "catalogued variants with no template: #{missing.inspect}"
    end

    it "has a catalog entry for every template file" do
      on_disk = Dir[File.join(TEMPLATE_ROOT, "*", "*.html.erb")]
                .reject { |f| File.basename(File.dirname(f)) == "icons" }
                .map { |f| "#{File.basename(File.dirname(f))}/#{File.basename(f, '.html.erb')}" }
      catalogued = Catalog::VARIANTS.flat_map { |c, vs| vs.map { |v| "#{c}/#{v[:name]}" } }

      expect((on_disk - catalogued)).to be_empty,
        "templates with no catalog entry: #{(on_disk - catalogued).inspect}"
    end

    it "flags exactly the variants whose markup references the icon sprite" do
      Catalog::VARIANTS.each do |category, variants|
        variants.each do |v|
          markup = File.read(File.join(TEMPLATE_ROOT, category, "#{v[:name]}.html.erb"))
          expect(markup.include?('xlink:href="#')).to eq(v[:icons]),
            "#{category}/#{v[:name]} :icons flag is #{v[:icons]} but markup says otherwise"
        end
      end
    end

    it "flags exactly the variants that reference docs-site placeholder images" do
      placeholders = ["bootstrap-docs.png", "bootstrap-themes.png",
                      "/docs/5.3/assets/", "unsplash-photo-"]

      Catalog::VARIANTS.each do |category, variants|
        variants.each do |v|
          markup = File.read(File.join(TEMPLATE_ROOT, category, "#{v[:name]}.html.erb"))
          expect(placeholders.any? { |p| markup.include?(p) }).to eq(!!v[:images]),
            "#{category}/#{v[:name]} :images flag is #{v[:images]} but markup says otherwise"
        end
      end
    end

    it "gives every variant a unique name within its category" do
      Catalog::VARIANTS.each do |category, variants|
        names = variants.map { |v| v[:name] }
        expect(names.uniq).to eq(names), "duplicate variant names in #{category}"
      end
    end
  end

  describe "the shipped snippet markup" do
    let(:templates) { Dir[File.join(TEMPLATE_ROOT, "*", "*.html.erb")] }

    it "carries no leftover docs page chrome" do
      offenders = templates.select do |f|
        body = File.read(f)
        body.include?("b-example-divider") || body.include?("bd-mode-toggle") ||
          body.match?(/<h1 class="visually-hidden">[^<]*examples/)
      end

      expect(offenders).to be_empty, "page chrome leaked into: #{offenders.inspect}"
    end

    it "keeps viewBox correctly cased so icons render" do
      offenders = templates.select { |f| File.read(f).include?("viewbox=") }

      expect(offenders).to be_empty, "lowercased viewBox (icons will not render) in: #{offenders.inspect}"
    end

    it "references only icons that the sprite defines" do
      sprite = File.read(File.join(TEMPLATE_ROOT, "icons", "_bootstrap_icons.html.erb"))
      defined_ids = sprite.scan(/<symbol id="([^"]+)"/).flatten

      referenced = templates.flat_map { |f| File.read(f).scan(/<use xlink:href="#([^"]+)"/).flatten }.uniq

      expect(referenced - defined_ids).to be_empty,
        "snippets reference icons missing from the sprite: #{(referenced - defined_ids).inspect}"
    end
  end

  describe "generating a snippet" do
    it "writes the default variant as a partial" do
      run_generator(generator_for("header"))

      expect(destination_exist?('app/views/shared/_header.html.erb')).to be true
    end

    it "writes the requested variant" do
      run_generator(generator_for("hero"), %w[dark])

      partial = read_destination('app/views/shared/_hero.html.erb')
      expected = File.read(File.join(TEMPLATE_ROOT, "heroes", "dark.html.erb"))
      expect(partial).to eq(expected)
    end

    it "accepts dashes in place of underscores" do
      run_generator(generator_for("footer"), %w[with-newsletter])

      expect(read_destination('app/views/shared/_footer.html.erb'))
        .to eq(File.read(File.join(TEMPLATE_ROOT, "footers", "with_newsletter.html.erb")))
    end

    it "honours --as" do
      run_generator(generator_for("footer"), %w[columns --as=site_footer])

      expect(destination_exist?('app/views/shared/_site_footer.html.erb')).to be true
      expect(destination_exist?('app/views/shared/_footer.html.erb')).to be false
    end

    it "honours --path" do
      run_generator(generator_for("badge"), %w[pills --path=app/views/components])

      expect(destination_exist?('app/views/components/_badge.html.erb')).to be true
    end

    it "tells the user how to render it" do
      output = run_generator(generator_for("modal"), %w[confirm])

      expect(output).to include('render "shared/modal"')
    end

    it "raises on an unknown variant, listing the valid ones" do
      expect {
        run_generator(generator_for("badge"), %w[neon])
      }.to raise_error(Rails::Generators::Error, /Unknown badges variant "neon".*pills, subtle/m)
    end
  end

  describe "the icons sprite" do
    it "is installed alongside a snippet that needs it" do
      run_generator(generator_for("header"), %w[dark_search])

      expect(destination_exist?('app/views/shared/_bootstrap_icons.html.erb')).to be true
    end

    it "is not installed for a snippet that does not use icons" do
      run_generator(generator_for("header"), %w[nav_pills])

      expect(destination_exist?('app/views/shared/_bootstrap_icons.html.erb')).to be false
    end

    it "can be skipped with --no-icons" do
      run_generator(generator_for("header"), %w[dark_search --no-icons])

      expect(destination_exist?('app/views/shared/_header.html.erb')).to be true
      expect(destination_exist?('app/views/shared/_bootstrap_icons.html.erb')).to be false
    end

    it "follows --path" do
      run_generator(generator_for("header"), %w[dark_search --path=app/views/components])

      expect(destination_exist?('app/views/components/_bootstrap_icons.html.erb')).to be true
    end
  end

  describe "--list" do
    it "prints each variant with its description and writes nothing" do
      output = run_generator(generator_for("sidebar"), %w[--list])

      expect(output).to include("icon_only")
      expect(output).to include("Narrow icon-only sidebar")
      expect(output).to include("Default: dark")
      expect(Dir.children(destination_root)).to be_empty
    end
  end

  describe "every generator" do
    Bootstrap::Generators::SnippetCatalog::GENERATORS.each do |generator_name, category|
      it "bootstrap:#{generator_name} generates each of its #{category} variants" do
        klass = generator_for(generator_name)

        Catalog.variant_names(category).each do |variant|
          remove_destination_root
          run_generator(klass, [variant])

          partial = destination_path("app/views/shared/_#{generator_name}.html.erb")
          expect(File.exist?(partial)).to be(true), "#{generator_name} #{variant} wrote nothing"
          expect(File.size(partial)).to be > 50
        end
      end
    end
  end
end
