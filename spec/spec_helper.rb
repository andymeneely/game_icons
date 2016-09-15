require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start do
  add_filter "/spec/"
end

require 'game_icons'

def repo(str)
  "#{File.expand_path('../../', __FILE__)}/#{str}"
end

def icon_file(str)
  repo("resources/icons/#{str}")
end

def data(file)
  repo("spec/data/#{file}")
end

def data_string(file)
  File.open(data(file), 'r').read
end
