require 'rails_helper'

RSpec.describe 'Photo Service: ', type: :feature do
  describe 'As a user when' do
    before(:each) do
      @location = 'cleveland, oh'
      @expected_reference = 'CmRaAAAAfny913NNeO6SIBfVvvdIiXGEeRAxWQH1Ffv2Z6MFTtth8IflrIovI04rhX_f9LigLheAaitXkfiTjkZA473D4KduNoXZ_GWYgX_RYlE7H15CKBwg1p94u2W_JXLho4SfEhC4_tHXZZATxbYymk4mPkqJGhRSpoiXvVKvaozNd58bzu066fU5hA'

      place_response = File.read('spec/fixtures/photo_service/cleveland_oh.json')
      stub_request(:get, "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=cleveland, oh&inputtype=textquery&fields=photos&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                  .to_return(status: 200, body: place_response, headers: {})
    end

    it 'I provide location I expect to get back a photo reference for that place' do
      expect(PhotoService.find_photo_reference(@location)).to eq(@expected_reference)
    end

    it 'I provide a location I get back a photo for that place' do
      expected = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1080&key=#{ENV['GOOGLE_GEOCODING_KEY']}&photoreference=#{@expected_reference}"

      expect(PhotoService.find_photo(@location)).to eq(expected)
    end
  end
end
