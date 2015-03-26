require 'spec_helper.rb'

RSpec.describe 'Hive Capture Application' do
  it 'should allow access to the home page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'should allow access to the main javascript page' do
    get '/script/appui/capture.js'
    expect(last_response).to be_ok
  end

  describe '#url' do
    before(:each) do
      @base_url = 'url_base'
    end

    it 'should add the base url to a url starting with a /' do
      expect(url('/test/path')).to eq '/url_base/test/path'
    end

    it 'should add the base url to a url not starting with a /' do
      expect(url('test/path')).to eq 'url_base/test/path'
    end
  end
end
