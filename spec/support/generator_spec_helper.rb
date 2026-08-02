require 'fileutils'
require 'tmpdir'
require 'stringio'
require 'rails'
require 'rails/generators'

require 'generators/bootstrap/install/install_generator'
require 'generators/bootstrap/layout/layout_generator'
require 'generators/bootstrap/starter/starter_generator'
require 'generators/bootstrap/cdn/cdn_generator'
require 'generators/bootstrap/snippets/snippet_catalog'

Bootstrap::Generators::SnippetCatalog::GENERATORS.each_key do |name|
  require "generators/bootstrap/#{name}/#{name}_generator"
end

# Support for driving the generators against a throwaway destination root.
module GeneratorSpecHelper
  def destination_root
    @destination_root ||= Dir.mktmpdir("tbr-generator-spec")
  end

  def remove_destination_root
    FileUtils.remove_entry(@destination_root) if @destination_root && File.exist?(@destination_root)
    @destination_root = nil
  end

  # Runs a generator against the destination root and returns what it printed.
  # Thor writes through $stdout, so capturing that captures generator chatter too.
  # :debug => true stops Thor from swallowing Thor::Error (which
  # Rails::Generators::Error subclasses) so specs can assert on it.
  def run_generator(klass, args = [], config = {})
    original = $stdout
    $stdout = StringIO.new
    begin
      klass.start(args, { :destination_root => destination_root, :debug => true }.merge(config))
      $stdout.string
    ensure
      $stdout = original
    end
  end

  def destination_path(relative)
    File.join(destination_root, relative)
  end

  def read_destination(relative)
    File.read(destination_path(relative))
  end

  def destination_exist?(relative)
    File.exist?(destination_path(relative))
  end

  def write_destination(relative, contents)
    path = destination_path(relative)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, contents)
    path
  end

  # A minimal stand-in for a host Rails application: enough for the generators
  # that read Rails.application for the app name and the template engine.
  def stub_rails_application(template_engine = :erb, app_name = "Dummy")
    generators = Struct.new(:options).new({ :rails => { :template_engine => template_engine } })
    config = Struct.new(:generators).new(generators)

    application_class = Class.new
    application_class.define_singleton_method(:to_s) { "#{app_name}::Application" }

    application = Object.new
    application.define_singleton_method(:config) { config }
    application.define_singleton_method(:class) { application_class }

    allow(::Rails).to receive(:application).and_return(application)
  end
end

RSpec.configure do |config|
  config.include GeneratorSpecHelper

  config.after(:each) do
    remove_destination_root
    Twitter::Bootstrap::Rails.asset_mode = :static
    Twitter::Bootstrap::Rails.asset_pipeline = nil
  end
end
