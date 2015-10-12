require 'game_icons/optional_deps'

module GameIcons
  class Icon
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def string
      @svgstr ||= File.open(@file) { |f| f.read }
    end

    # Modify the background and foreground colors
    def recolor(bg: '#000', fg: '#fff')
      OptionalDeps.require_nokogiri
      doc     = Nokogiri::XML(self.string)
      doc.css('path')[0]['fill'] = bg # red background
      doc.css('path')[1]['fill'] = fg # green background
      @svgstr = doc.to_xml
      self
    end

    # Fix an incompatibility issue with Gimp & Inkscape
    # Replaces path strings like "1.5-1.5" with "1.5 -1.5"
    def correct_pathdata
      10.times do # this is a bit of a hack b/c my regex isn't perfect
        @svgstr = self.string
          .gsub(/(\d)\-/,'\1 -')                  # separate negatives
          .gsub(/(\.)(\d+)(\.)/,'\1\2 \3') # separate multi-decimals
        end
      self
    end

  end
end