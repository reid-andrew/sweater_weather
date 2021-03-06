require 'rails_helper'

RSpec.describe 'Gecoding Service: ', type: :feature do
  describe 'As a user when' do
    it 'I provide a location I want to get back a lat/long' do
      location = "Cleveland, OH"
      expected = {:lat=>41.49932, :lng=>-81.6943605}
      json_response = File.read('spec/fixtures/geocoding_service/cleveland_oh.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Cleveland,%2BOH&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_geocode(location)
      expect(geocode[:results][0][:geometry][:location]).to eq(expected)
    end

    it 'I provide a different location I want to get back a lat/long' do
      location = "Denver CO"
      expected = {"lat": 39.7392358, "lng": -104.990251}
      json_response = File.read('spec/fixtures/geocoding_service/denver_co.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Denver%2BCO&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_geocode(location)
      expect(geocode[:results][0][:geometry][:location]).to eq(expected)
    end

    it 'I provide only a country I get back a lat/long' do
      location = "italy"
      expected = {"lat": 41.87194, "lng": 12.56738}
      json_response = File.read('spec/fixtures/geocoding_service/italy.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=italy&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

      geocode = GeocodingService.find_geocode(location)
      expect(geocode[:results][0][:geometry][:location]).to eq(expected)
    end

    it 'I provide gibberish I get back zero results' do
      location = "4$73f123asdf"
      expected = {:results=>[], :status=>"ZERO_RESULTS"}
      json_response = File.read('spec/fixtures/geocoding_service/no_results.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=4$73f123asdf&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: json_response, headers: {})

    geocode = GeocodingService.find_geocode(location)
    expect(geocode).to eq(expected)
    end
  end
end
