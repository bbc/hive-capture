require 'spec_helper.rb'

describe 'Hive Capture Application' do
  it 'should allow access to the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'should allow access to the main javascript page' do
    get '/script/appui/capture.js'
    expect(last_response).to be_ok
  end
end
