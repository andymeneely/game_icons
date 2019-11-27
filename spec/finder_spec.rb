require 'game_icons/finder.rb'
require 'spec_helper'

describe GameIcons::Finder do
  let(:glass_heart_file) { icon_file("lorc/glass-heart.svg") }
  let(:flame_file)       { icon_file("carl-olsen/flame.svg") }
  let(:skoll_jeep)       { icon_file("skoll/jeep.svg") }
  let(:delapouite_jeep)  { icon_file("delapouite/jeep.svg") }

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
    expect { subject.find('macguffin')}.to raise_error(RuntimeError)
  end

  it 'finds an icon with an author too' do
    expect(subject.find("skoll/jeep").file).to eq(skoll_jeep)
    expect(subject.find("delapouite/jeep").file).to eq(delapouite_jeep)
  end

end
