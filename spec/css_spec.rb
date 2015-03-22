require 'spec_helper.rb'

RSpec.describe 'CSS endpoints' do
  it 'should allow access to the base CSS file' do
    get '/style/base.css'
    expect(last_response).to be_ok
  end

  it 'should allow access to the base CSS file' do
    get '/style/layouts/540p.css'
    expect(last_response).to be_ok
  end

  it 'should allow access to the base CSS file' do
    get '/style/layouts/720p.css'
    expect(last_response).to be_ok
  end

  it 'should allow access to the base CSS file' do
    get '/style/layouts/1080p.css'
    expect(last_response).to be_ok
  end
end
