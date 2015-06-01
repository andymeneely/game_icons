require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'launchy'

task default: [:install, :spec]

RSpec::Core::RakeTask.new(:spec)

desc 'Stitch and recolor every icon into a giant sheet'
task :sanity => :install do
  require 'game_icons/tasks/sanity_test'
  GameIcons::SanityTest.run
  Launchy.open("file:///" + File.expand_path('./sanity_test.png', File.dirname(__FILE__)))
end

desc 'Download and unzip the latest icons'
task :update do
  require 'game_icons/tasks/update'
  GameIcons::Update.run
end
