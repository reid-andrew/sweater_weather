require 'rails_helper'

RSpec.describe 'Road_Trip Endpoint -', type: :request do
  before(:each) do
    params = {"email": "whatever@example.com", "password": "password", "password_confirmation": "password"}
    @user = User.create!(params)

    json_response = File.read('spec/fixtures/geocoding_service/pueblo_co.json')
    stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Pueblo,%2BCO&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                .to_return(status: 200, body: json_response, headers: {})

    json_response = File.read('spec/fixtures/open_weather_service/pueblo_co.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=38.2544472&lon=-104.6091409&units=imperial")
                .to_return(status: 200, body: json_response, headers: {})

    @starting_road_trip_count = RoadTrip.count
  end

  it 'creates road trips' do
    post '/api/v1/road_trip', params:
      {
        "origin": "Denver, CO",
        "destination": "Pueblo, CO",
        "api_key": "#{@user.api_key}"
      }
      output = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(RoadTrip.count - @starting_road_trip_count).to eq(1)
      expect(output[:data][:attributes][:origin]).to eq(RoadTrip.last.origin)
      expect(output[:data][:attributes][:destination]).to eq(RoadTrip.last.destination)
      expect(output[:data][:attributes][:travel_time]).to eq(RoadTrip.last.travel_time)
      expect(output[:data][:attributes][:forecast_temp]).to eq(RoadTrip.last.forecast_temp)
      expect(output[:data][:attributes][:forecast_description]).to eq(RoadTrip.last.forecast_description)
  end

end
