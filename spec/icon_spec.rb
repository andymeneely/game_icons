require 'spec_helper'
require 'stringio'

describe GameIcons::Icon do

  context(:file) do
    it 'returns the file given' do
      expect(GameIcons::Icon.new('foo.svg').file).to eq('foo.svg')
    end
  end

  context(:string) do
    it 'opens the file properly on to_s' do
      i = GameIcons::Icon.new(data('foo.svg'))
      expect(i.string).to eq('<svg><path fill="abc"/><path fill="def"/></svg>')
    end
  end

  context(:recolor) do
    it 'recolors regular colors' do
      exp = <<~EOSVG
        <?xml version="1.0"?>
        <svg>
          <path fill="123" fill-opacity="1.0"/>
          <path fill="456" fill-opacity="1.0"/>
        </svg>
      EOSVG
      i = GameIcons::Icon.new(data('foo.svg'))
      expect(i.recolor(bg: '#123', fg: '#456').string).to eq(exp)
    end

    it 'recolors with fill opacity too' do
      exp = <<~EOSVG
        <?xml version="1.0"?>
        <svg>
          <path fill="123" fill-opacity="0.25"/>
          <path fill="456" fill-opacity="0.12"/>
        </svg>
      EOSVG
      i = GameIcons::Icon.new(data('foo.svg'))
      actual = i.recolor(bg: '#123', fg: '#456',
                         bg_opacity:'0.25', fg_opacity:'0.12').string
      expect(actual).to eq(exp)
    end
  end

  context(:correct_pathdata) do
    it 'corrects space issue' do
      exp = data_string('glass-heart-corrected.svg').strip
      expect(GameIcons.get('glass-heart').correct_pathdata.string).to eq(exp)
    end
  end

end
