require 'game_icons/db'
require 'game_icons/icon'
require 'game_icons/did_you_mean'

module GameIcons
  class Finder

    # Find the icon, possibly without the extension.
    # @example Finder.new.find('glass-heart')
    # Raises an error if the icon could not be found.
    def find(icon)
      str = icon.to_s.downcase
      file = DB.files[str] ||
               DB.files[str.sub(/\.svg$/,'')] ||
               not_found(str, icon)
      Icon.new(file)
    end

    private
    def not_found(str, orig_str)
      dym = DidYouMean.new(DB.names).query(str)
      raise("game_icons: could not find icon '#{orig_str}'. Did you mean any of these? #{dym.join(', ')}")
    end

  end
end
