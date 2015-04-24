require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task default: [:install, :spec]

RSpec::Core::RakeTask.new(:spec)

task :sanity => :install do
  require 'game_icons/sanity_test'
  SanityTest.run
end
