require 'rails_helper'

RSpec.describe 'Background Endpoint -', type: :request do
  before(:each) do
    json_response = File.read('spec/fixtures/geocoding_service/pueblo_co.json')
    stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=pueblo,co&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                .to_return(status: 200, body: json_response, headers: {})

    json_response = File.read('spec/fixtures/open_weather_service/pueblo_co.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=38.2544472&lon=-104.6091409&units=imperial")
                .to_return(status: 200, body: json_response, headers: {})
  end

  it 'gets food info for a given location' do
    get '/api/v1/foodie?start=denver,co&end=pueblo,co&search=italian'
    json_response = JSON.parse(response.body)
    expected = json_response[:data]

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(expected[:type]).to eq('foodie')
    expect(expected[:attributes][:end_location]).to eq('pueblo, co')
    expect(expected[:attributes][:travel_time]).to eq('1 hours 48 min')
    expect(expected[:attributes][:forecast][:summary]).to eq('TBD')
    expect(expected[:attributes][:forecast][:temperature]).to eq('TBD')
    expect(expected[:attributes][:restaurant][:name]).to eq('TBD')
    expect(expected[:attributes][:restaurant][:address]).to eq('TBD')
  end
end
