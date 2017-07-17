namespace :logger do
  desc "Logs "
  task daemon: :environment do
    Rails.logger       = Logger.new(Rails.root.join('log', 'daemon.log'))
    Rails.logger.level = Logger.const_get(ENV.fetch('LOG_LEVEL', 'info').upcase)
  
    if ENV['BACKGROUND']
      Process.daemon(true, true)
    end
  
    if ENV['PIDFILE']
      File.open(ENV['PIDFILE'], 'w') { |f| f << Process.pid }
    end
  
    stop_signal = false
  
    Signal.trap('TERM') { stop_signal = true }
    Signal.trap('SIGINT') { stop_signal = true }
  
    Rails.logger.info "Start daemon..."
  
    device = ENV.fetch('I2C_DEVICE_ID', ENV['I2C_DEVICE'] || 1)
  
    bme280 = I2C::Driver::BME280.new(device: device)
  
    loop do
      break if stop_signal
      
      TphData.create(bme280.all) do |d|
        d.timestamp = DateTime.now
      end
  
      sleep (ENV['INTERVAL'] || 1).to_i
    end
  end

end
