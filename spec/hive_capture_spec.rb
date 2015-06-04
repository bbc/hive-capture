require 'spec_helper.rb'

RSpec.describe 'Hive Capture Application' do
  describe 'Index' do
    it 'should allow access to the home page' do
      get '/',
        {},
        { 'REMOTE_ADDR' => '1.2.3.4' }
      expect(last_response).to be_ok
    end

    it 'should allow access to the main javascript page' do
      get '/script/appui/capture.js'
      expect(last_response).to be_ok
    end
  end

  describe 'RC' do
    it 'should allow access to the RC' do
      get '/rc'
      expect(last_response).to be_ok
    end
  end

  describe 'AIT' do
    it 'should allow access to the AIT' do
      get '/ait/'
      expect(last_response).to be_ok
    end
  end
end
