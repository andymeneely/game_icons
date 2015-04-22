require 'game_icons/finder.rb'
require 'spec_helper'

describe GameIcons::Finder do
  it 'returns the path of a known icon' do
    expect(subject.find('glass-heart')).to eq(repo("resources/icons/lorc/originals/svg/glass-heart.svg"))
  end

  it 'raises and exception upon not finding it' do
    expect { subject.find('macguffin')}.to raise_error("game_icons: could not find icon 'macguffin'")
  end

end