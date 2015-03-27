require 'sinatra'
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'hive_capture'

disable :run

map '/titantv' do
  run HiveCapture
end

