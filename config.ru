require 'sinatra'
require File.join(File.dirname(__FILE__), 'hive_capture')

disable :run

map '/titantv' do
  run HiveCapture
end

