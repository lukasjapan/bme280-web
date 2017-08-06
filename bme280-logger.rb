require 'bundler'
Bundler.setup

require 'yaml'
require 'i2c/bme280'
require_relative 'spec/fake_bme280'
require_relative 'models/tph_data'

# env
env = ENV.fetch('RACK_ENV', 'development')

# Load settings
settings = YAML.load_file(File.expand_path("config/settings-#{env}.yml", File.dirname(__FILE__)))
database = YAML.load_file(File.expand_path('config/database.yml', File.dirname(__FILE__)))

bme280 = if settings['logger']['fakedata']
           FakeBme280.new
         else
           I2C::Driver::BME280.new(device: settings['i2c_bme280']['device_id'])
         end

# Daemonize if requested
if settings['logger']['background']
  Process.daemon(true, true)
end

# Trigger for quitting the logger
$quit = false

# tell logger to quit if signal is received
Signal.trap('TERM') { puts 'TERM signal trapped.'; $quit = true }
Signal.trap('SIGINT') { puts 'SIGINT signal trapped.'; $quit = true }

# sleep that is interrupted if the logger should quit
def breakable_sleep(seconds:, step:)
  t = 0.0
  while(t < seconds)
    sleep(step)
    break if $quit
    t += step
  end
end

# Connect to db
ActiveRecord::Base.establish_connection(database[env])
ActiveRecord::Base.logger = Logger.new(STDOUT)

# log data until a quit signal is received
loop do
  break if $quit

  TphData.create_from_bme280(bme280)

  breakable_sleep(seconds: settings['logger']['interval'], step: [settings['logger']['interval'], 0.1].min)
end