#!/usr/bin/env ruby

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path(
  '../Gemfile',
  Pathname.new(__FILE__).realpath
)
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/antie_config'
require 'chamber'

APPLICATION_ID = 'hive_capture'

Chamber.load(
  basepath: File.expand_path('..', Pathname.new(__FILE__).realpath),
  namespaces: { environment: ENV['HIVE_ENVIRONMENT'] || 'development' }
)

enable :sessions
set :bind, '0.0.0.0'

configure do
  mime_type :js, 'text/javascript'
  mime_type :css, 'text/css'
end

before '/script/*' do
  content_type :js
end

before '/style/*' do
  content_type :css
end

get '/' do
  erb :index
end

get '/poll' do
  erb :poll_json
end

# Main page
get '/script/appui/capture.js' do
  erb :script_appui_capture_js
end

# Components
get '/script/appui/components/titleContainer.js' do
  erb :script_appui_components_titleContainer_js
end

get '/script/appui/components/deviceInformation.js' do
  erb :script_appui_components_deviceInformation_js
end

get '/script/appui/components/hiveStats.js' do
  erb :script_appui_components_hiveStats_js
end

# Layouts
get '/script/appui/layouts/:size.js' do
  erb :script_appui_layout_js
end

get '/style/layouts/:size.css' do
  erb :style_layouts_css
end

def height(size)
  size.scan(/^(\d+)p/)[0][0].to_i
end

def width(size)
  16 * height(size) / 9
end

def font_size(size)
  height(size) / 20
end

def left_margin(size)
  - height(size) / 2
end

def mac(ip)
  `ping -c 1 #{ip}`
  mac = '00:00:00:00:00:00'
  if RUBY_PLATFORM =~ /darwin/
    mac = `arp -n #{ip} | awk '{ print \$4 }'`.chomp
  elsif RUBY_PLATFORM =~ /linux/
    mac = `arp -an #{ip} | awk '{ print \$4 }'`.chomp
  end

  mac.split(/:/).map { |n| n.rjust(2, '0') }.join(':')
end
