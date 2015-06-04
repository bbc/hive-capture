require 'spec_helper.rb'
require 'hive_capture/data_store'

RSpec.describe 'HiveCapture::DataStore' do
  after(:each) do
    HiveCapture::DataStore.instance_variable_set(:@devices, {})
  end

  describe 'device' do
    it 'creates an entry for an unknown device' do
      expect(HiveCapture::DataStore.device(1)).to eq({delay_history: {}})
    end

    it 'sets a value for a new device' do
      HiveCapture::DataStore.device(1)[:key] = 'value'
      expect(HiveCapture::DataStore.instance_variable_get(:@devices)[1]).to include({key: 'value'})
    end

    it 'gets an entry for a known device' do
      HiveCapture::DataStore.device(1)[:key] = 'value'
      expect(HiveCapture::DataStore.device(1)).to include({key: 'value'})
    end

    it 'sets a value for a known device' do
      HiveCapture::DataStore.device(1)[:key] = 'value'
      HiveCapture::DataStore.device(1)[:key2] = 'value2'
      expect(HiveCapture::DataStore.instance_variable_get(:@devices)[1]).to include({key: 'value', key2: 'value2'})
    end

    it 'sets a value for two separate devices' do
      HiveCapture::DataStore.device(1)[:key1] = 'value1'
      HiveCapture::DataStore.device(2)[:key2] = 'value2'
      expect(HiveCapture::DataStore.device(1)).to include({key1: 'value1'})
      expect(HiveCapture::DataStore.device(2)).to include({key2: 'value2'})
    end
  end

  describe 'get_poll_delays' do
    it 'gets an empty list of poll delays' do
      expect(HiveCapture::DataStore.get_poll_delays).to eq({})
    end

    it 'gets a single poll delay' do
      HiveCapture::DataStore.poll_delay(1, 5.1)
      expect(HiveCapture::DataStore.get_poll_delays).to match({1 => 5.1})
    end

    it 'gets two poll delays' do
      HiveCapture::DataStore.poll_delay(1, 5.1)
      HiveCapture::DataStore.poll_delay(2, 3.2)
      expect(HiveCapture::DataStore.get_poll_delays).to match({1 => 5.1, 2 => 3.2})
    end
  end

  describe 'poll_delay' do
    it 'sets the delay time for a device' do
      HiveCapture::DataStore.poll_delay(1, 5.1)
      expect(HiveCapture::DataStore.instance_variable_get(:@devices)[1]).to include({delay: 5.1})
    end

    it 'updates the delay time for a device' do
      HiveCapture::DataStore.poll_delay(1, 5.1)
      HiveCapture::DataStore.poll_delay(1, 2.3)
      #expect(HiveCapture::DataStore.instance_variable_get(:@devices)).to include({1 => {delay: 2.3}})
      expect(HiveCapture::DataStore.instance_variable_get(:@devices)[1]).to include({delay: 2.3})
    end
  end
end
