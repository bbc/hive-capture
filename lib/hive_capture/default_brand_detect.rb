class HiveCapture
  module AntieConfig
    def brand
      session[:brand] = params['brand'] || session[:brand] || 'default'
    end

    def model
      session[:model] = params['model'] || session[:model] || 'webkit'
    end

    def device_type
      # For the moment only TVs are supported
      'tv'
    end
  end
end
