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

    def recolor(bg: '#000', fg: '#fff')
      OptionalDeps.require_nokogiri
      doc     = Nokogiri::XML(self.string)
      doc.css('path')[0]['fill'] = bg # red background
      doc.css('path')[1]['fill'] = fg # green background
      @svgstr = doc.to_xml
      self
    end

  end
end