require 'game_icons'
require 'cairo'
require 'pango'
require 'rsvg2'

module GameIcons
  class SanityTest
    def self.run(size: 100)
      num = GameIcons.names.count
      cc  = Cairo::Context.new(Cairo::ImageSurface.new(1200, ((num / 12) + 1) * size))
      scale = size / 512.0
      cc.scale(size / 512.0, size / 512.0)
      GameIcons.names.each_with_index do |icon, i|
        icon  = GameIcons.get(icon).recolor(fg: '#CBB08B', bg: '#5F443A')
        svg   = RSVG::Handle.new_from_data(icon.string)
        x     = (i % 12) * size / scale
        y     = (i / 12) * size / scale
        cc.translate(x, y)
        cc.render_rsvg_handle(svg)
        cc.translate(-x, -y)
      end
      cc.target.write_to_png('sanity_test.png')
      puts "Done!"
    end
  end
end