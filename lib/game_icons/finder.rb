module GameIcons

  class Finder
    @@icons = Hash.new

    def initialize
      init_icon_db
    end

    def init_icon_db
      return unless @@icons.empty?
      resources = File.expand_path('../../resources', File.dirname(__FILE__))
      Dir.glob("#{resources}/**/*.svg").each do |svg|
        @@icons[File.basename(svg,'.svg')] = svg
      end
    end

    def find(icon)
      @@icons[icon] || raise("game_icons: could not find icon '#{icon}'")
    end
  end

end