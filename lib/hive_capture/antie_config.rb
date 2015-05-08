require 'sinatra'
require 'sinatra/base'
require 'json'

class HiveCapture
  module AntieConfig
    require "hive_capture/#{Chamber.env[:device_detect] || 'default_device_detect'}"
    def doc_type
      page_strategy_element('doctype', '<!DOCTYPE html>')
    end

    def root_element
      page_strategy_element('rootelement', '<html>')
    end

    def device_header
      page_strategy_element('header')
    end

    def device_body
      page_strategy_element('body')
    end

    def index_mime_type
      page_strategy_element('mimetype', 'text/html')
    end

    def config_path
      Chamber.env[:device_config] || 'public/antie/config/devices'
    end

    def page_strategy_path
      Chamber.env[:page_strategy] || 'public/antie/config/pagestrategy'
    end

    def configuration(file = false)
      config = "#{brand}-#{model}-default"
      config = 'default-webkit-default' if ! File.file?("#{config_path}/#{config}.json")
      file ? "#{config_path}/#{config}.json" : config
    end

    def configuration_string(app_id)
      config = ''
      File.open(configuration(true), 'r') do |f|
        f.each_line do |line|
          config += line.sub('%application%', app_id)
        end
      end
      config
    end

    def page_strategy(dir = false)
      ps = JSON.parse(File.read(configuration(true)))['pageStrategy']
      dir ? "#{page_strategy_path}/#{ps}" : ps
    end

    def page_strategy_element(element, default='')
      File.file?("#{page_strategy(true)}/#{element}") ? File.read("#{page_strategy(true)}/#{element}").chomp : default
    end
  end
end
