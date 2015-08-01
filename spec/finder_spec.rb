require 'game_icons/finder.rb'
require 'spec_helper'

describe GameIcons::Finder do
  let(:glass_heart_file) { repo("resources/icons/lorc/originals/svg/glass-heart.svg") }
  let(:flame_file)       { repo("resources/icons/carl-olsen/originals/svg/flame.svg") }

  it 'returns the path of a known icon' do
    expect(subject.find('glass-heart').file).to eq(glass_heart_file)
  end

  it 'allows the svg extension' do
    expect(subject.find('glass-heart.svg').file).to eq(glass_heart_file)
  end

  it 'ignores case ' do
    expect(subject.find('GLASS-HEART.svg').file).to eq(glass_heart_file)
  end

  it 'works with symbols too' do
    expect(subject.find(:flame).file).to eq(flame_file)
  end

  it 'raises and exception upon not finding it' do
    expect { subject.find('macguffin')}.to raise_error(start_with("game_icons: could not find icon 'macguffin'"))
  end

end
