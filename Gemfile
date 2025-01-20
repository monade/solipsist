source "https://rubygems.org"
gemspec

rails_version = ENV['CI_RAILS_VERSION'] || '>= 0.0'

gem 'yard'

if ['~> 8.0.0', '>= 0', '>= 0.0'].include?(rails_version)
  gem 'sqlite3', '~> 2'
else
  gem 'sqlite3', '~> 1'
end

gem 'rails', rails_version
gem 'rubocop-rails', require: false
gem 'logger'
gem 'benchmark'
gem 'bigdecimal'
gem 'mutex_m'
gem 'drb'
