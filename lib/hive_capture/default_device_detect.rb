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

    def ip_address
      request.ip == '127.0.0.1' ? @env['HTTP_X_FORWARDED_FOR'].split(',')[0] : request.ip
    end

    def mac
      `ping -c 1 #{ip_address}`
      mac = '00:00:00:00:00:00'
      if RUBY_PLATFORM =~ /darwin/
        mac = `arp -n #{ip_address} | awk '{ print \$4 }'`.chomp
      elsif RUBY_PLATFORM =~ /linux/
        mac = `arp -an #{ip_address} | awk '{ print \$4 }'`.chomp
      end

      # Match a valid MAC address or return the default
      /^([0-9a-fA-F]{1,2}:){5}[0-9a-fA-F]{1,2}$/ =~ mac ?
        mac.split(/:/).map { |n| n.rjust(2, '0') }.join(':') :
        'a0:b0:c0:d0:e0:01'
    end
  end
end
