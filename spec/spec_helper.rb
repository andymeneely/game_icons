require 'game_icons'

RSpec.configure do |config|
  config.color = true  # Use color in STDOUT
end

def repo(str)
  "#{File.expand_path('../../', __FILE__)}/#{str}"
end

def icon_file(str)
  repo("resources/icons/ffffff/000000/1x1/#{str}")
end

def data(file)
  repo("spec/data/#{file}")
end

def data_string(file)
  File.open(data(file), 'r').read
end
