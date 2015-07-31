require 'spec_helper'
require 'game_icons/did_you_mean'

describe GameIcons::DidYouMean do

  context '#query with basic data' do
    let(:dym) { GameIcons::DidYouMean.new(%w(foo food bar barista))}

    it 'gets an exact match first' do
      expect(dym.query('foo', 2)).to eq(%w(foo food))
    end

    it 'strips spaces' do
      expect(dym.query('  foo  ', 1)).to eq(%w(foo))
    end

    it 'finds transposed letters first' do
      expect(dym.query('ofo', 2)).to eq(%w(foo food))
    end

    it 'finds scrambled letters easily' do
      expect(dym.query('aataistrb', 2)).to eq(%w(barista bar))
    end

    it ('ignores dashes')      { expect(dym.query('fo-o', 1)).to(eq(%w(foo))) }
    it ('ignores underscores') { expect(dym.query('fo_o', 1)).to eq(%w(foo)) }
    it ('ignores case')        { expect(dym.query('FoO',  1)).to eq(%w(foo)) }

  end

  context '#query on real data' do
    let(:dym) { GameIcons::DidYouMean.new(GameIcons.names) }

    it 'gets glass-heart' do
      expect(dym.query('glaheart').first).to eq('glass-heart')
    end

  end

  # Yes, I'm testing private methods. Get over it. I don't trust myself.
  context '#lex' do
    let(:did_you_mean) { GameIcons::DidYouMean.new(%w(foo bar))}

    it 'indexes letter_freqs' do
      expect(did_you_mean.send(:lex, %w(foo bar))).to eq(
        {
          'foo' => { 'f' => 1, 'o' => 2, 'fo' => 1, 'oo' => 1, 'foo' => 1 },
          'bar' => { 'b' => 1, 'a' => 1, 'r' => 1, 'ba' => 1, 'ar' => 1, 'bar' => 1 },
        }
      )
    end
  end

  context '#char_freq' do
    let(:dym) { GameIcons::DidYouMean.new([])}

    it 'parses a regular word' do
      expect(dym.send(:char_freq, 'food')).to eq(
          { 'f' => 1, 'o' => 2, 'd' => 1,
            'fo' => 1, 'oo' => 1, 'od' => 1,
            'foo' => 1, 'ood' => 1,
            'food' => 1,
          }
      )
    end

    it 'parses a longer word' do
      expect(dym.send(:char_freq, 'foood')).to eq(
          { 'f' => 1, 'o' => 3, 'd' => 1,
            'fo' => 1, 'oo' => 2, 'od' => 1,
            'foo' => 1, 'ooo' => 1, 'ood' => 1,
            'fooo' => 1, 'oood' => 1,
          }
      )
    end
  end

  context '#score' do
    let(:did_you_mean) { GameIcons::DidYouMean.new([])}
    let(:foo)      { Hash.new(0).merge({ 'f' => 1, 'o' => 2 }) }
    let(:food)     { Hash.new(0).merge({ 'f' => 1, 'o' => 2, 'd' => 1 }) }
    let(:bar)      { Hash.new(0).merge({ 'b' => 1, 'a' => 1, 'r' => 1 }) }
    let(:barista)  { Hash.new(0).merge({ 'b' => 1, 'a' => 2, 'r' => 1, 'i' => 1, 's' => 1, 't' => 1 }) }

    it 'is zero on the same freqs' do
      expect(did_you_mean.send(:score, foo, foo)).to eq(0)
    end

    it 'works on foo vs. food' do
      expect(did_you_mean.send(:score, foo, food)).to eq(1)
    end

    it 'works on food vs. foo' do
      expect(did_you_mean.send(:score, food, foo)).to eq(1)
    end

    it 'works on foo vs. bar' do
      expect(did_you_mean.send(:score, foo, bar)).to eq(6)
    end

    it 'works on bar vs. barista' do
      expect(did_you_mean.send(:score, bar, barista)).to eq(4)
    end

  end


end
