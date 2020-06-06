require 'rails_helper'

RSpec.describe 'Gecoding Service: ', type: :feature do
  describe 'As a user when' do
    it 'I provide an address I want to get back a lat/long' do
      location = "2401 Ontario St, Cleveland, OH"
      expected = {"lat": 41.4956363, "lng": -81.6847398}
      json_response = File.read('spec/fixtures/geocoding_service/2401_ontario.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=2401%2BOntario%2BSt,%2BCleveland,%2BOH&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end

    it 'I provide an incomplete address I want to get back a lat/long' do
      location = "Denver CO"
      expected = {"lat": 39.7392358, "lng": -104.990251}
      json_response = File.read('spec/fixtures/geocoding_service/denver_co.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Denver%2BCO&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end

    it 'I provide only a country I get back a lat/long' do
      location = "italy"
      expected = {"lat": 41.87194, "lng": 12.56738}
      json_response = File.read('spec/fixtures/geocoding_service/italy.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=italy&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end

    it 'I provide gibberish I get back an empty hash' do
      location = "4$73f123asdf"
      expected = {}
      json_response = File.read('spec/fixtures/geocoding_service/no_results.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=4$73f123asdf&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end
  end
end
