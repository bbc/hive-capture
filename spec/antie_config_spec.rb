require 'spec_helper'
require 'sinatra/antie_config'

get '/spec/brand' do
  brand
end

get '/spec/model' do
  model
end

get '/spec/device_type' do
  device_type
end

get '/spec/doc_type' do
  doc_type
end

get '/spec/root_element' do
  root_element
end

get '/spec/device_header' do
  device_header
end

get '/spec/device_body' do
  device_body
end

get '/spec/configuration' do
  configuration
end

get '/spec/configuration_string' do
  configuration_string(params['app_id'])
end

RSpec.describe Sinatra::AntieConfig do
  describe '#brand' do
    it 'returns default brand with no session or parameter' do
      get '/spec/brand'
      expect(last_response.body).to eq 'default'
    end

    it 'returns a brand given in the parameter list' do
      get '/spec/brand', { brand: 'brand_in_params' }
      expect(last_response.body).to eq 'brand_in_params'
    end

    it 'returns a brand set in the session' do
      get '/spec/brand', { brand: 'brand_in_params' }
      get '/spec/brand'
      expect(last_response.body).to eq 'brand_in_params'
    end

    it 'overrides the session by setting the parameter' do
      get '/spec/brand', { brand: 'brand_in_params' }
      get '/spec/brand', { brand: 'brand_in_params_2' }
      expect(last_response.body).to eq 'brand_in_params_2'
    end
  end

  describe '#model' do
    it 'returns webkit model with no session or parameter' do
      get '/spec/model'
      expect(last_response.body).to eq 'webkit'
    end

    it 'returns a model given in the parameter list' do
      get '/spec/model', { model: 'model_in_params' }
      expect(last_response.body).to eq 'model_in_params'
    end

    it 'returns a model set in the session' do
      get '/spec/model', { model: 'model_in_params' }
      get '/spec/model'
      expect(last_response.body).to eq 'model_in_params'
    end

    it 'overrides the session by setting the parameter' do
      get '/spec/model', { model: 'model_in_params' }
      get '/spec/model', { model: 'model_in_params_2' }
      expect(last_response.body).to eq 'model_in_params_2'
    end
  end

  describe '#device_type' do
    it 'returns tv with no session or parameter' do
      get '/spec/device_type'
      expect(last_response.body).to eq 'tv'
    end
  end

  describe '#doc_type' do
    it 'returns the default doc type' do
      get '/spec/doc_type'
      expect(last_response.body).to eq '<!DOCTYPE html>'
    end
  end

  describe '#root_element' do
    it 'returns the default root element' do
      get '/spec/root_element'
      expect(last_response.body).to eq '<html>'
    end
  end

  describe '#device_header' do
    it 'returns the default device_header' do
      get '/spec/device_header'
      expect(last_response.body).to eq ''
    end
  end

  describe '#device_body' do
    it 'returns the default device_body' do
      get '/spec/device_body'
      expect(last_response.body).to eq ''
    end
  end

  describe '#configuration' do
    it 'returns the configuration name for the device and model' do
      get '/spec/configuration', { brand: 'test_brand', model: 'test_model' }
      expect(last_response.body).to eq 'test_brand-test_model-default'
    end
  end

  describe '#configuration_string' do
    it 'returns a valid configuration string' do
      get '/spec/configuration_string', { app_id: 'test_app' }
      expect(last_response.body).to match /\s*{.*}\s*/m
    end
  end

  describe '#width' do

  end
end
