require "game_icons/version"
require 'game_icons/finder'

module GameIcons
  def self.find(name)
    Finder.new.find(name)
  end
end
