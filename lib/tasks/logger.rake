require_relative '../../spec/fake_bme280'

namespace :logger do
  desc "Logs "
  task daemon: :environment do
    Rails.logger       = Logger.new(Rails.root.join('log', 'daemon.log'))
    Rails.logger.level = Logger.const_get(ENV.fetch('LOG_LEVEL', 'info').upcase)

    bme280 = I2C::Driver::BME280.new(device: Rails.configuration.x.bme280.i2c_device_id)

    if ENV['BACKGROUND']
      Process.daemon(true, true)
    end
  
    stop_signal = false
  
    Signal.trap('TERM') { stop_signal = true }
    Signal.trap('SIGINT') { stop_signal = true }
  
    Rails.logger.info "Starting daemon..."
  
    loop do
      break if stop_signal

      TphData.create_from_bme280(bme280)
  
      sleep (ENV['INTERVAL'] || 1).to_i
    end
  end

  desc "Produces fake data for development on machines without the BME280."
  task fakedata: :environment do
    raise ArgumentError, 'Use this task for development only.' unless Rails.env.development?

    fake_bme280 = FakeBme280.new

    stop_signal = false

    Signal.trap('SIGINT') { stop_signal = true }

    loop do
      break if stop_signal

      TphData.create_from_bme280(fake_bme280)

      sleep (ENV['INTERVAL'] || 1).to_i
    end
  end
end
