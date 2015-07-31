require 'game_icons/db'

module GameIcons
  class DidYouMean
    def initialize(names)
      @letter_freqs = lex(names)
    end

    def query(q, result_size = 5)
      q = scrub(q.downcase.strip)
      q_freq = char_freq(q)
      scores = Hash.new(0)
      @letter_freqs.each do |name, freq|
        scores[name] = score(freq, q_freq)
      end
      top(result_size, scores)
    end

    private
    def lex(names)
      names.inject({}) do |freqs, name|
        freqs[name] = char_freq(scrub(name.downcase.strip))
        freqs
      end
    end

    # Computes a hash of each character
    def char_freq(str)
      freqs = Hash.new(0)
      (1..4).each do |i|
        str.chars.each_cons(i).inject(freqs) do |freq, ngram|
          ngram = ngram.join
          freq[ngram] = freq[ngram] + 1
          freq
        end
      end
      freqs
    end

    def scrub(str)
      str.gsub(/[^a-z]/i, '')
    end

    def score(n_freq, q_freq)
      score = 0
      # Go over every freq in the query

      # q_freq.each do |c, count|
      #   score += (n_freq[c] - count).abs
      # end
      # Go over everything in n that was not in query
      (n_freq.keys + q_freq.keys).uniq.each do |k|
        score += (n_freq[k] - q_freq[k]).abs
      end
      score
    end

    # Return top scoring, sorted by lowest
    def top(n, scores)
      scores.sort {|a,b| a[1] <=> b[1]}.map{|x| x[0]}.first(n)
    end


  end
end
