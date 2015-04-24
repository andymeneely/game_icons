require 'spec_helper'

describe GameIcons::OptionalDeps do

  it 'works fine in dev' do
    GameIcons::OptionalDeps.require_nokogiri
    expect(defined? Nokogiri).to eq('constant')
  end

end