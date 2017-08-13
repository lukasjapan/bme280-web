ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'coveralls'

formatter = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatter)
SimpleCov.start

require 'rspec'
require 'rack/test'
require 'timecop'
require 'database_cleaner'
require_relative 'fake_bme280'
require_relative '../bme280-web'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
