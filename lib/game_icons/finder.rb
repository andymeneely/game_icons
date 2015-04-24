require 'game_icons/db'
require 'game_icons/icon'

module GameIcons
  class Finder

    # Find the icon, possibly without the extension.
    # @example Finder.new.find('glass-heart')
    # Raises an error if the icon could not be found.
    def find(icon)
      str = icon.to_s.downcase
      file = DB.files[str] ||
               DB.files[str.sub(/\.svg$/,'')] ||
               raise("game_icons: could not find icon '#{icon}'")
      Icon.new(file)
    end
  end
end