require 'rails_helper'

RSpec.describe 'Gecoding Service: ', type: :feature do
  describe 'As a user when' do
    it 'I provide an address I want to get back a lat/long' do
      location = "2401 Ontario St, Cleveland, OH"
      expected = {"lat": 41.4956363, "lng": -81.6847398}

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end

    it 'I provide an incomplete address I want to get back a lat/long' do
      location = "Denver CO"
      expected = {"lat": 39.7392358, "lng": -104.990251}

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end

    it 'I provide only a country I get back a lat/long' do
      location = "italy"
      expected = {"lat": 41.87194, "lng": 12.56738}

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end

    it 'I provide gibberish I get back an empty hash' do
      location = "4$73f123a!#sdf"
      expected = {}

      geocode = GeocodingService.find_coordinates(location)
      expect(geocode).to eq(expected)
    end
  end
end
