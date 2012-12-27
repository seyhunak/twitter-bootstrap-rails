#!/usr/bin/env rake
require 'bundler'
Bundler::GemHelper.install_tasks

desc "Bundle the gem"
task :bundle  => [:bundle_install, :build_static_stylesheets] do
  sh 'gem build *.gemspec'
  sh 'gem install *.gem'
  sh 'rm *.gem'
end

desc "Runs bundle install"
task :bundle_install do
  sh('bundle install')
end

desc "Build the static precompiled stylesheets from Less sources"
task :build_static_stylesheets do
  require 'less'

  toolkit_path = File.join('vendor', 'toolkit')

  parser = Less::Parser.new :paths => [toolkit_path]

  target_directory = File.expand_path('vendor/assets/stylesheets/twitter-bootstrap-static')

  sh "rm -rf #{target_directory}"
  sh "mkdir -p #{target_directory}"
  Dir['vendor/static-source/*.less'].each do |source_file|
    puts "Compiling #{source_file}"
    target_file = File.join(target_directory, File.basename(source_file, '.less')+'.css.erb')
    tree = parser.parse(File.read(source_file))
    File.open(target_file, 'w') {|f| f.puts tree.to_css(:compress => true) }
  end
end

task(:default).clear
task :default => :bundle
