require 'sinatra'
require 'sinatra/base'

class HiveCapture
  module AntieConfig
    require "hive_capture/#{Chamber.env[:device_detect] || 'default_device_detect'}"
    def doc_type
      '<!DOCTYPE html>'
    end

    def root_element
      '<html>'
    end

    def device_header
      ''
    end

    def device_body
      ''
    end

    def config_path
      Chamber.env.device_config || 'public/antie/config/devices'
    end

    def configuration(file = false)
      config = "#{brand}-#{model}-default"
puts ">>>> #{config} <<<<"
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
  end
end
