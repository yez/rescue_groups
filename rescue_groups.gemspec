$LOAD_PATH << File.dirname(__FILE__)
require 'version'

Gem::Specification.new do |s|
  s.name          = 'rescue_groups'
  s.version       = RescueGroups::VERSION
  s.summary       = %q{RescueGroups.org API wrapper}
  s.description   = %q{Ruby ORM for the RescueGroups API. On demand pet data provided for free by RescueGroups.org.}
  s.authors       = ['Jake Yesbeck']
  s.email         = 'yesbeckjs@gmail.com'
  s.homepage      = 'http://rubygems.org/gems/rescue_groups'
  s.license       = 'MIT'

  s.require_paths = %w(lib models search config)
  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(/^spec\//)

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'httparty', '>= 0.13.0'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'guard-rspec'
end
