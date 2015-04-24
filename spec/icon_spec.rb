require 'spec_helper'
require 'stringio'

describe GameIcons::Icon do

  it 'opens the file properly on to_s' do
    i = GameIcons::Icon.new(data('foo.svg'))
    expect(i.string).to eq('<svg><path fill="abc"/><path fill="def"/></svg>')
  end

  it 'recolors properly' do
    i = GameIcons::Icon.new(data('foo.svg'))
    expect(i.recolor(bg: '123', fg: '456').string)
      .to eq("<?xml version=\"1.0\"?>\n<svg>\n  <path fill=\"123\"/>\n  <path fill=\"456\"/>\n</svg>\n")
  end

  it 'returns the file given' do
    expect(GameIcons::Icon.new('foo.svg').file).to eq('foo.svg')
  end

end
