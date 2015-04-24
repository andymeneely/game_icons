require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'game_icons'

def repo(str)
  "#{File.expand_path('../../', __FILE__)}/#{str}"
end

def data(str)
  repo("spec/data/#{str}")
end