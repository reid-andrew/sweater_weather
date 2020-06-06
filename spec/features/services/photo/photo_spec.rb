require 'rails_helper'

RSpec.describe 'Photo Service: ', type: :feature do
  describe 'As a user when' do
    it 'I provide location I expect to get back a photo reference for that place' do
      location = 'Cleveland, OH'
      expected_reference = 'CmRaAAAAfny913NNeO6SIBfVvvdIiXGEeRAxWQH1Ffv2Z6MFTtth8IflrIovI04rhX_f9LigLheAaitXkfiTjkZA473D4KduNoXZ_GWYgX_RYlE7H15CKBwg1p94u2W_JXLho4SfEhC4_tHXZZATxbYymk4mPkqJGhRSpoiXvVKvaozNd58bzu066fU5hA'

      place_response = File.read('spec/fixtures/photo_service/cleveland_oh.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Cleveland, OH&inputtype=textquery&fields=photos&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: place_response, headers: {})

      expect(PhotoService.find_photo_reference(location)).to eq(expected_reference)
    end

    it 'I provide a location I get back a photo for that place' do
      location = 'Cleveland, OH'

      place_response = File.read('spec/fixtures/photo_service/cleveland_oh.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Cleveland, OH&inputtype=textquery&fields=photos&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: place_response, headers: {})

      photo_response = File.read('spec/fixtures/photo_service/94eaba86-e0a6-4d9f-a05f-9743b5380549-response.jpg')
      stub_request(:get, "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1600&key=#{ENV['GOOGLE_GEOCODING_KEY']}&photoreference=CmRaAAAAfny913NNeO6SIBfVvvdIiXGEeRAxWQH1Ffv2Z6MFTtth8IflrIovI04rhX_f9LigLheAaitXkfiTjkZA473D4KduNoXZ_GWYgX_RYlE7H15CKBwg1p94u2W_JXLho4SfEhC4_tHXZZATxbYymk4mPkqJGhRSpoiXvVKvaozNd58bzu066fU5hA")
                  .to_return(status: 200, body: photo_response, headers: {})

      expect(PhotoService.find_photo(location)).to eq(photo_response)
    end
  end
end
