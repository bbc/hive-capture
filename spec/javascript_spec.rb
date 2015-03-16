require 'spec_helper.rb'

describe 'Javascript endpoints' do
  it 'should allow access to the main javascript page' do
    get '/script/appui/capture.js'
    expect(last_response).to be_ok
  end

  it 'should allow access to RequireJS' do
    get '/antie/static/script/lib/require.js'
    expect(last_response).to be_ok
  end

  it 'should allow access to the title container' do
    get '/script/appui/components/titleContainer.js'
    expect(last_response).to be_ok
  end

  it 'should allow access to the device information container' do
    get '/script/appui/components/deviceInformation.js'
    expect(last_response).to be_ok
  end

  it 'should allow access to the hive stats container' do
    get '/script/appui/components/hiveStats.js'
    expect(last_response).to be_ok
  end

  describe 'Layouts' do
    it 'should allow access to the 540p layout file' do
      get '/script/appui/layouts/540p.js'
      expect(last_response).to be_ok
    end

    it 'should allow access to the 720p layout file' do
      get '/script/appui/layouts/720p.js'
      expect(last_response).to be_ok
    end

    it 'should allow access to the 1080p layout file' do
      get '/script/appui/layouts/1080p.js'
      expect(last_response).to be_ok
    end
  end
end
