require 'rails_helper'

RSpec.describe 'Open Weather Service: ', type: :feature do
  describe 'As a user when' do
    it 'I a lat/long I get back the weather' do
      coordinates = {lat: 41.4956363, lng: -81.6847398}
      json_response = File.read('spec/fixtures/open_weather_service/2401_ontario.json')
      stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=41.4956363&lon=-81.6847398")
                  .to_return(status: 200, body: json_response, headers: {})

      openweather = OpenWeatherService.find_weather(coordinates)
      expect(openweather[:current][:sunrise]).to eq(1591437208)
      expect(openweather[:current][:weather][0][:description]).to eq('few clouds')
      expect(openweather[:hourly][0][:humidity]).to eq(68)
      expect(openweather[:hourly][0][:weather][0][:description]).to eq('few clouds')
      expect(openweather[:daily][7][:sunset]).to eq(1592096494)
      expect(openweather[:daily][7][:weather][0][:description]).to eq('heavy intensity rain')
    end
  end
end
