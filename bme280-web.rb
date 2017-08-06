require 'bundler'
Bundler.setup

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/config_file'
require 'sinatra/reloader' if development?
require_relative 'models/tph_data'

# env
env = ENV.fetch('RACK_ENV', 'development')

# Load settings (the sinatra way)
config_file File.expand_path("config/settings-#{env}.yml", File.dirname(__FILE__))

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

  s = params[:s].to_i || 5*60

  @data = TphData.where('timestamp > ?', s.seconds.ago)

  content_type :json

  slim :data
end

# Get records in a time range
get '/range.json' do
  from = params[:from].to_datetime
  to = params[:to].to_datetime

  @data = TphData.where('timestamp >= ? and timestamp <= ?', from, to)

  content_type :json

  slim :data
end

