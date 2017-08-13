require 'bundler'
Bundler.setup

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/config_file'
require 'sinatra/reloader' if development?
require_relative 'models/tph_data'

class BME280Web < Sinatra::Base
  register Sinatra::ConfigFile

  # Load settings
  config_file File.expand_path("config/settings-#{ENV.fetch('RACK_ENV', 'development')}.yml", File.dirname(__FILE__))

  helpers do
    def pack_src(name)
      base = case
               when settings.development?
                 config = settings.webpacker_dev_server
                 "http://#{config['host']}:#{config['port']}/"
               else
                 '/'
             end

      "<script src=\"#{base}#{name}.js\" type=\"text/javascript\"></script>"
    end
  end

  # Serve HTML
  get '/' do
    slim :index, layout: :application
  end

  # Get the latest records
  get '/latest.json' do
    content_type :json

    s = (params[:s] || 5*60).to_i

    @data = TphData.where('timestamp > ?', s.seconds.ago)

    slim :data
  end

  # Get records in a time range
  get '/range.json' do
    content_type :json

    begin
      from = params[:from].to_datetime
      to = params[:to].to_datetime
    rescue => e
      halt 400, e.message.to_json
    end

    @data = TphData.where('timestamp >= ? and timestamp <= ?', from, to)

    slim :data
  end

  run! if __FILE__ == $0
end
