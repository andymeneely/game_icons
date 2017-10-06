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

    # Modify the background and foreground colors and their opacities
    def recolor(bg: '#000', fg: '#fff', bg_opacity: "1.0", fg_opacity: "1.0")
      OptionalDeps.require_nokogiri
      bg.prepend('#') unless bg.start_with? '#'
      fg.prepend('#') unless fg.start_with? '#'
      doc     = Nokogiri::XML(self.string)
      doc.css('path')[0]['fill'] = #000 # dark backdrop
      doc.css('path')[1]['fill'] = #fff # light drawing
      doc.css('path')[0]['fill-opacity'] = bg_opacity.to_s # dark backdrop
      doc.css('path')[1]['fill-opacity'] = fg_opacity.to_s # light drawing
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
