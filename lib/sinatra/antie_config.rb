require 'sinatra'
require 'sinatra/base'

module Sinatra
  module AntieConfig
    def brand
      session[:brand] = params['brand'] || session[:brand] || 'default'
    end

    def model
      session[:model] = params['model'] || session[:model] || 'webkit'
    end

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

    def configuration
      "#{brand}-#{model}-default"
    end

    def configuration_string(app_id)
      configuration_file = "public/antie/config/devices/#{configuration}.json"
      configuration = ''
      File.open(configuration_file, 'r') do |f|
        f.each_line do |line|
          configuration += line.sub('%application%', app_id)
        end
      end
      configuration
    end
  end

  helpers AntieConfig
end
