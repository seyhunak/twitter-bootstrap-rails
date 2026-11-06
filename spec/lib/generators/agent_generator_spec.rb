require 'spec_helper'

describe Bootstrap::Generators::AgentGenerator do
  let(:rails_mod) { Twitter::Bootstrap::Rails }
  let(:skill_path) { ".claude/skills/bootstrap-rails/SKILL.md" }

  before { stub_rails_application }

  def skill
    read_destination(skill_path)
  end

  def agents
    read_destination("AGENTS.md")
  end

  it "writes a Claude skill with the frontmatter Claude needs" do
    run_generator(described_class)

    expect(skill).to start_with("---\nname: bootstrap-rails\ndescription: ")
  end

  it "writes the guide to AGENTS.md" do
    run_generator(described_class)

    expect(agents).to include("Bootstrap #{rails_mod::BOOTSTRAP_VERSION}")
  end

  it "keeps what is already in AGENTS.md" do
    write_destination("AGENTS.md", "# My rules\n\nUse tabs.\n")

    run_generator(described_class)

    expect(agents).to start_with("# My rules\n\nUse tabs.\n")
    expect(agents).to include("Bootstrap #{rails_mod::BOOTSTRAP_VERSION}")
  end

  it "replaces its own section when run again instead of adding another" do
    write_destination("AGENTS.md", "# My rules\n")
    rails_mod.asset_pipeline = :sprockets
    run_generator(described_class)
    rails_mod.asset_pipeline = :propshaft
    run_generator(described_class)

    expect(agents.scan("bootstrap-rails:start").size).to eq(1)
    expect(agents).to include("Propshaft")
    expect(agents).not_to include("Sprockets directives")
    expect(agents).to start_with("# My rules\n")
  end

  it "does not stop to ask when the skill already exists" do
    run_generator(described_class)
    rails_mod.asset_pipeline = :propshaft
    allow($stdin).to receive(:gets).and_raise("prompted for input")

    expect { run_generator(described_class) }.not_to raise_error
    expect(skill).to include("Propshaft")
  end

  it "skips each file on request" do
    run_generator(described_class, %w[--no-claude])
    expect(destination_exist?(skill_path)).to be false
    expect(destination_exist?("AGENTS.md")).to be true

    FileUtils.rm(destination_path("AGENTS.md"))
    run_generator(described_class, %w[--no-agents])
    expect(destination_exist?(skill_path)).to be true
    expect(destination_exist?("AGENTS.md")).to be false
  end

  it "writes nothing with --pretend" do
    write_destination("AGENTS.md", "# Mine\n")

    run_generator(described_class, %w[--pretend])

    expect(agents).to eq("# Mine\n")
    expect(destination_exist?(skill_path)).to be false
  end

  describe "the guide" do
    it "describes this app's setup" do
      rails_mod.asset_pipeline = :propshaft
      stub_rails_application(:haml)
      run_generator(described_class)

      expect(skill).to include("Propshaft").and include("Template engine: haml")
    end

    it "lists every snippet generator and variant from the catalog" do
      run_generator(described_class)
      catalog = Bootstrap::Generators::SnippetCatalog

      catalog::GENERATORS.each do |generator, category|
        expect(skill).to include("bootstrap:#{generator}")
        catalog.variant_names(category).each { |variant| expect(skill).to include(variant) }
      end
    end

    it "names the old markup to avoid, from the same table the doctor uses" do
      run_generator(described_class)

      expect(skill).to include("data-toggle").and include("btn-default").and include("btn-secondary")
    end

    it "tells agents how to check their work" do
      run_generator(described_class)

      expect(skill).to include("rails g bootstrap:doctor --json")
    end
  end
end
