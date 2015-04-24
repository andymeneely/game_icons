require "game_icons/version"
require 'game_icons/finder'
require 'game_icons/db'
require 'game_icons/optional_deps'

module GameIcons
  def self.get(name)
    Finder.new.find(name)
  end

  def self.names
    DB.names
  end
end
