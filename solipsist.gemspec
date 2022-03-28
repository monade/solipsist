# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'solipsist/version'

Gem::Specification.new do |s|
  s.name        = 'solipsist'
  s.version     = Solipsist::VERSION
  s.date        = '2022-03-28'
  s.summary     = 'An approach to write controllers in a super compact way.'
  s.description = 'An approach to write controllers in a super compact way.'
  s.authors     = ['Mònade']
  s.email       = 'team@monade.io'
  s.files = Dir['lib/**/*']
  s.test_files = Dir['spec/**/*']
  s.required_ruby_version = '>= 2.6.0'
  s.homepage    = 'https://rubygems.org/gems/solipsist'
  s.license     = 'MIT'
  s.add_dependency 'cancancan'
  s.add_dependency 'activesupport', ['>= 5', '< 8']
  s.add_dependency 'active_model_serializers', '~> 0.10'
  s.add_development_dependency 'rspec-rails', '~> 3'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'activemodel', ['>= 5', '< 8']
end
