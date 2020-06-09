require 'rails_helper'

RSpec.describe 'Direction Service: ', type: :feature do
  describe 'As a user when' do
    it 'I provide an origin & destination & get back a travel time' do
      directions_json_response = File.read('spec/fixtures/directions/denver_to_pueblo.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?destination=Pueblo,%20CO&key=#{ENV['GOOGLE_GEOCODING_KEY']}&origin=Denver,%20CO")
                  .to_return(status: 200, body: directions_json_response, headers: {})

      origin = "Denver, CO"
      destination = "Pueblo, CO"
      directions = DirectionService.find_distance(origin, destination)

      expect(directions[:routes][0][:legs][0][:duration][:text]).to eq('1 hour 48 mins')
      expect(directions[:routes][0][:legs][0][:duration][:value]).to eq(6479)
    end
  end
end
