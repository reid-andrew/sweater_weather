require 'rails_helper'

RSpec.describe 'Forecast Endpoint -', type: :request do
  before(:each) do
    json_response = File.read('spec/fixtures/geocoding_service/cleveland_oh.json')
    stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=cleveland,%2Boh&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                .to_return(status: 200, body: json_response, headers: {})

    json_response = File.read('spec/fixtures/open_weather_service/cleveland_oh.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=41.49932&lon=-81.6943605&units=imperial")
                .to_return(status: 200, body: json_response, headers: {})
  end

  it 'provides current_conditions for a city' do
    weather_fixture = File.read('spec/fixtures/open_weather_service/cleveland_oh.json')
    weather = JSON.parse(weather_fixture, symbolize_names: true)

    geocode_fixture = File.read('spec/fixtures/geocoding_service/cleveland_oh.json')
    geocode = JSON.parse(geocode_fixture, symbolize_names: true)

    get '/api/v1/forecast?location=cleveland, oh'
    expected = JSON.parse(response.body)

    expect(response).to be_successful
    expect(expected["data"]["id"]).to eq("cleveland, oh - #{weather[:current][:dt]}")
    expect(expected["data"]["attributes"]["location"]["city"]).to eq(geocode[:results][0][:address_components][0][:long_name])
    expect(expected["data"]["attributes"]["location"]["state"]).to eq(geocode[:results][0][:address_components][2][:short_name])
    expect(expected["data"]["attributes"]["location"]["country"]).to eq(geocode[:results][0][:address_components][3][:long_name])
    expect(expected["data"]["attributes"]["current_weather"]["time"]).to eq(Time.at(weather[:current][:dt]).strftime('%l:%M %p, %B%e'))
    expect(expected["data"]["attributes"]["current_weather"]["current_temp"]).to eq(weather[:current][:temp])
    expect(expected["data"]["attributes"]["current_weather"]["high"]).to eq(weather[:daily][0][:temp][:max])
    expect(expected["data"]["attributes"]["current_weather"]["low"]).to eq(weather[:daily][0][:temp][:min])
  end
end
