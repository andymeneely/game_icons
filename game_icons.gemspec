# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'game_icons/version'

Gem::Specification.new do |spec|
  spec.specification_version = 2 if spec.respond_to? :specification_version=
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=
  spec.required_ruby_version = '>= 2.0.0'

  spec.name          = "game_icons"
  spec.version       = GameIcons::VERSION
  spec.authors       = ["Andy Meneely"]
  spec.email         = ["andy.meneely@gmail.com"]
  spec.summary       = %q{Icons from game-icons.net}
  spec.description   = %q{Access and manipulate the scalable, free icons of game-icons.net}
  spec.homepage      = "https://github.com/andymeneely/game_icons"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'cairo'
  spec.add_development_dependency 'pango'
  spec.add_development_dependency 'rsvg2'
  spec.add_development_dependency 'launchy'
end
