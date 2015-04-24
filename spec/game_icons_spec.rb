require 'spec_helper'
require 'game_icons'

describe GameIcons do
  let(:finder) { double(GameIcons::Finder) }

  it 'creates a new finder and calls its find' do
    expect(GameIcons::Finder).to     receive(:new).and_return(finder)
    expect(finder).to                receive(:find).with('foo').and_return('bar')
    expect(GameIcons.get('foo')).to  eq('bar')
  end

  it 'calls DB directly for names' do
    expect(GameIcons::DB).to   receive(:names).and_return(['foo'])
    expect(GameIcons.names).to eq(['foo'])
  end
end