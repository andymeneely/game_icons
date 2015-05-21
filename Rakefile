require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'launchy'

task default: [:install, :spec]

RSpec::Core::RakeTask.new(:spec)

task :sanity => :install do
  require 'game_icons/sanity_test'
  SanityTest.run
  Launchy.open("file:///" + File.expand_path('./sanity_test.png', File.dirname(__FILE__)))
end
