require 'rails_helper'

RSpec.describe 'Forecast Endpoint - ', type: :request do
  before(:each) do

  end

  it 'provides current_conditions for a city' do
    weather_fixture = File.read('spec/fixtures/open_weather_service/2401_ontario.json')
    weather = JSON.parse(weather_fixture, symbolize_names: true)

    geocode_fixture = File.read('spec/fixtures/geocoding_service/2401_ontario.json')
    geocode = JSON.parse(geocode_fixture, symbolize_names: true)

    get '/api/v1/forecast?location=cleveland, oh'
    expected = JSON.parse(response.body)

    expect(response).to be_successful
    expect(expected["data"][0]["attributes"]["city"]).to eq(geocode[:results][0][:address_components][3][:long_name])
    expect(expected["data"][0]["attributes"]["state"]).to eq(geocode[:results][0][:address_components][5][:short_name])
    expect(expected["data"][0]["attributes"]["country"]).to eq(geocode[:results][0][:address_components][6][:long_name])
    expect(expected["data"][0]["attributes"]["time"]).to eq(Time.at(weather[:current][:dt]).strftime('%l:%M %p, %B%e'))
    expect(expected["data"][0]["attributes"]["current_temp"]).to eq(weather[:current][:temp])
    expect(expected["data"][0]["attributes"]["forecast_high"]).to eq(weather[:daily][0][:temp][:max])
    expect(expected["data"][0]["attributes"]["forecast_low"]).to eq(weather[:daily][0][:temp][:min])
  end
end
