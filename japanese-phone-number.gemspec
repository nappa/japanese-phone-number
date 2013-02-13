# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'japanese-phone-number/version'

Gem::Specification.new do |gem|
  gem.name          = "japanese-phone-number"
  gem.version       = JapanesePhoneNumber::VERSION
  gem.authors       = ["Ryosuke Yamazaki"]
  gem.email         = ["ryosuke.yamazaki@mac.com"]
  gem.description   = "Japanese Phone Number Validator"
  gem.summary       = "Japanese Phone Number Validator"
  gem.homepage      = ""

  gem.add_development_dependency('rake')
  gem.add_development_dependency('mechanize')
  gem.add_development_dependency('nokogiri')
  gem.add_development_dependency('roo')
  gem.add_development_dependency('test-unit')
  gem.add_development_dependency('shoulda')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
