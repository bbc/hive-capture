require 'spec_helper.rb'
require 'json'
require 'cgi'

class HiveCapture
  # Override mac function
  def mac
    'aa:aa:%02x:%02x:%02x:%02x' % ip_address.split(/\./)
  end
end

RSpec.describe 'Hive Capture Polling' do
  let(:register_response) {
    {}
  }
  let(:device_details) {
    [
      {
        ip: '10.10.10.7',
        mac: 'aa:aa:0a:0a:0a:07',
        model: 'TestModel',
        brand: 'TestBrand',
        type: 'tv',
        id: 1,
        name: 'Test device 1',
        status: 'Test status 1',
        hive: 'Test hive 1'
      },
      {
        ip: '10.10.10.11',
        mac: 'aa:aa:0a:0a:0a:0b',
        model: 'TestModel',
        brand: 'TestBrand',
        type: 'tv',
        id: 2,
        name: 'Test device 2',
        status: 'Test status 2',
        hive: 'Test hive 2'
      },
    ]
  }

  describe 'Registration' do
    before(:each) do
      device_details.each do |s|
        stub_request(:post, "http://test-devicedb/devices/register.json").
                 with(:body => "device_brand=#{CGI.escape(s[:brand])}&device_range=#{CGI.escape(s[:model])}&device_type=#{CGI.escape(s[:type])}&mac=#{CGI.escape(s[:mac])}",
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => register_response.merge(id: s[:id], name: s[:name], status: s[:status], hive: s[:hive]).to_json, :headers => {})
      end
    end

    it 'should allow access to the polling page' do
      d = device_details[0]
      get '/poll/',
        { brand: d[:brand], brand: d[:brand], model: d[:model], type: d[:type] },
        { 'REMOTE_ADDR' => d[:ip] }
      expect(last_response).to be_ok
    end

    it 'should register an unknown device' do
      d = device_details[0]
      get '/poll/',
        { brand: d[:brand], brand: d[:brand], model: d[:model], type: d[:type] },
        { 'REMOTE_ADDR' => d[:ip] }
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['id']).to be 1
    end

    it 'should register two different devices' do
      d1 = device_details[0]
      d2 = device_details[1]
      get '/poll/',
        { brand: d1[:brand], brand: d1[:brand], model: d1[:model], type: d1[:type] },
        { 'REMOTE_ADDR' => d1[:ip] }
      id1 = JSON.parse(last_response.body)['id']
      get '/poll/',
        { brand: d2[:brand], brand: d2[:brand], model: d2[:model], type: d2[:type] },
        { 'REMOTE_ADDR' => d2[:ip] }
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['id']).to_not be id1
    end

    it 'should return a name, status and hive' do
      d = device_details[0]
      get '/poll/',
        { brand: d[:brand], brand: d[:brand], model: d[:model], type: d[:type] },
        { 'REMOTE_ADDR' => d[:ip] }
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['name']).to eq 'Test device 1'
      expect(parsed_response['status']).to eq 'Test status 1'
      expect(parsed_response['hive']).to eq 'Test hive 1'
    end
  end

  describe 'polling' do
    before(:each) do
      stub_request(:post, "http://test-devicedb/devices/register.json").
               with(:body => "id=1",
                    :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => register_response.merge(id: 1, name: 'Test device', status: 'Test status', hive: 'Test hive', message: 'Test message', ).to_json, :headers => {})
    end
    it 'should return a name, status, hive, message and message type' do
      skip 'TODO'
      get '/poll/1',
        { },
        { 'REMOTE_ADDR' => '10.10.10.16' }
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['name']).to eq 'Test device'
      expect(parsed_response['status']).to eq 'Test status'
      expect(parsed_response['hive']).to eq 'Test hive'
    end
  end
end
