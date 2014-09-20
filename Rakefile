#!/usr/bin/env rake
require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Bundle the gem"
task :bundle  => [:bundle_install] do
  sh 'gem build *.gemspec'
  sh 'gem install *.gem'
  sh 'rm *.gem'
end

desc "Runs bundle install"
task :bundle_install do
  sh('bundle install')
end

task(:default).clear
task :default => :bundle

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = ['--color', '--format', 'doc']
end