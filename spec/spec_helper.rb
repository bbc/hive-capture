ENV['HIVE_ENVIRONMENT'] = 'rspec'
ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require 'simplecov'
require 'webmock/rspec'
SimpleCov.start

require File.expand_path '../../hive_capture.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }

def session
  last_request.env['rack.session']
end
