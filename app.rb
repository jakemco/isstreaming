#!/usr/bin/env ruby
# Encoding: UTF-8

require 'sinatra'
require 'yaml'
require 'haml'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'


set :bind, '0.0.0.0'
set :port, 3000
enable :dump_errors, :raise_errors, :show_exceptionss

set :haml, :format => :html5

config = YAML.load_file('config.yml')
puts config.inspect

##
# Default to turnin page
#
get '/' do
  stream = false

  uri = URI.parse "https://api.twitch.tv/kraken/streams/#{config[:user]}"
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  response = http.get(uri.request_uri)
  json = JSON.parse(response.body)
  puts json['stream'].inspect

  stream = json['stream'] != nil

  haml :index, :locals => { stream: stream }
end

