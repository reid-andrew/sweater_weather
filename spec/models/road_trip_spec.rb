require 'rails_helper'

RSpec.describe RoadTrip, type: :model do
  describe "validations" do
    it { should validate_presence_of(:origin)}
    it { should validate_presence_of(:destination)}
    it { should validate_presence_of(:travel_time)}
    it { should validate_presence_of(:forecast_temp)}
    it { should validate_presence_of(:forecast_description)}
    it { should validate_presence_of(:trip_date)}
  end

  describe "relationships" do
    it { should belong_to(:user)}
  end

  describe "model methods" do
    before(:each) do
      params = {"email": "whatever@example.com", "password": "password", "password_confirmation": "password"}
      @user = User.create!(params)

      json_response = File.read('spec/fixtures/geocoding_service/pueblo_co.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Pueblo,%2BCO&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      json_response = File.read('spec/fixtures/open_weather_service/pueblo_co.json')
      stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=38.2544472&lon=-104.6091409&units=imperial")
                  .to_return(status: 200, body: json_response, headers: {})

      directions_json_response = File.read('spec/fixtures/directions/denver_to_pueblo.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?destination=Pueblo,%20CO&key=#{ENV['GOOGLE_GEOCODING_KEY']}&origin=Denver,%20CO")
                  .to_return(status: 200, body: directions_json_response, headers: {})
    end

    it '.create_trip' do
      trip_count = RoadTrip.count
      RoadTrip.create_trip('Denver, CO', 'Pueblo, CO', @user)

      expect(RoadTrip.count).to eq(trip_count + 1)
      expect(RoadTrip.last.origin).to eq('Denver, CO')
      expect(RoadTrip.last.destination).to eq('Pueblo, CO')
    end
  end
end
