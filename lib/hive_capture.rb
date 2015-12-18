#!/usr/bin/env ruby

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path(
  '../../Gemfile',
  Pathname.new(__FILE__).realpath
)
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'chamber'
require 'devicedb_comms'
require 'mind_meld'
require 'simple_stats_store/file_dump'
require 'fileutils'

Chamber.load(
  basepath: File.expand_path('../..', Pathname.new(__FILE__).realpath),
  namespaces: { environment: ENV['HIVE_ENVIRONMENT'] || 'development' }
)

class HiveCapture < Sinatra::Base
  require 'hive_capture/antie_config'
  require 'hive_capture/data_store'
  helpers AntieConfig

  APPLICATION_ID = 'hive_capture'
  @base_url = Chamber.env.base? ? Chamber.env.base : '/'

  set :root, File.expand_path('../../', Pathname.new(__FILE__).realpath)

  enable :sessions
  set :bind, '0.0.0.0'
  set :protection, except: :frame_options

  DeviceDBComms.configure do |config|
    config.url = Chamber.env.devicedb_url
    if Chamber.env.cert?
      config.pem_file = Chamber.env.cert
      config.ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  configure do
    mime_type :js, 'text/javascript'
    mime_type :css, 'text/css'
    mime_type :rc, 'text/plain'
    mime_type :ait, 'application/vnd.dvb.ait+xml'
    set :mind_meld, {}
  end

  before '/script/*' do
    content_type :js
  end

  before '/style/*' do
    content_type :css
  end

  get '/' do
    content_type index_mime_type
    session['whoami'] = params['whoami'] || session['whoami']
    session['url'] = request.url.split(/\?/)[0]
    erb :index
  end

  get '/poll/' do
    content_type :js
    db = DeviceDBComms::Device.new

    # DeviceDB registration
    response = db.register(mac: mac, device_range: model, device_brand: brand, device_type: device_type)
    if response.has_key?('id')
      begin
        FileUtils.ln_s("#{settings.public_folder}/delays.png", "#{settings.public_folder}/#{response['id']}.png")
      rescue Errno::EEXIST
        puts "Image for #{response['id']} already exists"
      end
    end

    if params.has_key?('callback')
      "#{params['callback']}(#{response.to_json});"
    else
      response.to_json
    end
  end

  get '/mm_poll/' do
    content_type :js
    tmp_mind_meld = MindMeld.new(
      url: Chamber.env.mind_meld? ? Chamber.env.mind_meld : nil ,
      device: {
        macs: [ mac ],
        ips: [ ip_address ],
        brand: brand,
        model: model,
        range: model,
        device_type: 'Tv'
      }
    )

    if tmp_mind_meld.id
      settings.mind_meld[tmp_mind_meld.id] = tmp_mind_meld
      response = {
        id: tmp_mind_meld.id,
        name: tmp_mind_meld.name,
      }
    else
      response = {
        id: '?',
        name: 'Unknown',
      }
    end

    if params.has_key?('callback')
      "#{params['callback']}(#{response.to_json});"
    else
      response.to_json
    end
  end

  get '/poll/:id' do
    content_type :js
    db = DeviceDBComms::Device.new

    t = Time.new
    response = db.set_application(params[:id].to_i, Chamber.env.app_name)
    delay = Time.new - t
    HiveCapture::DataStore.poll_delay(params[:id].to_i, delay)
    data_dump = SimpleStatsStore::FileDump.new(Chamber.env.stats_directory, max: 500)
    data_dump.write(:delay, { timestamp: Time.now.strftime("%Y-%m-%d %H:%M:%S.%L"), device_id: params[:id].to_i, delay: delay} )

    if ! response['action']
      response['action'] = {
        'action_type' => 'message',
        'body' => "Last poll: %0.2f seconds" % delay
      }
    end

    if params.has_key?('callback')
      "#{params['callback']}(#{response.to_json});"
    else
      response.to_json
    end
  end

  get '/mm_poll/:id' do
    content_type :js

    if settings.mind_meld[params['id'].to_i]
      response = settings.mind_meld[params['id'].to_i].poll
      response = {
        action: { 'action_type' => 'message', 'body' => 'Doing nothing again' }
      }
    else
      response = {
        action: { 'action_type' => 'message', 'body' => 'Doing nothing failing' }
      }
    end

    if params.has_key?('callback')
      "#{params['callback']}(#{response.to_json});"
    else
      response.to_json
    end
  end

  # Layouts
  get '/style/layouts/:size.css' do
    erb :style_layouts_css
  end

  # Broadcast autolaunch
  get '/rc' do
    content_type :rc
    erb :rc,
        locals: {
          author: Chamber.env[:author] || 'E Noether',
          app_name: Chamber.env[:app_name].upcase || 'NO APPLICATION NAME',
          app_subdirectory: "#{Chamber.env[:app_subdirectory]}" || ''
        }
  end

  get '/ait/' do
    content_type :ait
    headers['Last-Modified'] = Time.now.strftime("%a, %d %b %Y %H:%M:%S GMT")
    headers['Accept-Ranges'] = 'bytes'
    erb :ait,
        locals: {
          org_id: Chamber.env[:org_id] || 0,
          app_id: Chamber.env[:app_id] || 0,
          app_widget_name: Chamber.env[:app_widget_name] || 'No Widget Name',
          app_params: Chamber.env[:app_params] || '?',
          app_name: Chamber.env[:app_name] || 'No Application Name',
          app_subdirectory: "#{Chamber.env[:app_subdirectory]}" || ''
        }
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
end
