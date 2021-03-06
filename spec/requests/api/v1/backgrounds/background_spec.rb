require 'rails_helper'

RSpec.describe 'Background Endpoint -', type: :request do
  it 'returns a background image url' do
    place_response = File.read('spec/fixtures/photo_service/cleveland_oh.json')
    stub_request(:get, "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=photos&input=cleveland,%20oh&inputtype=textquery&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                .to_return(status: 200, body: place_response, headers: {})

    get '/api/v1/backgrounds?location=cleveland, oh'
    @expected = JSON.parse(response.body)

    test = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1080&key=#{ENV['GOOGLE_GEOCODING_KEY']}&photoreference=CmRaAAAAfny913NNeO6SIBfVvvdIiXGEeRAxWQH1Ffv2Z6MFTtth8IflrIovI04rhX_f9LigLheAaitXkfiTjkZA473D4KduNoXZ_GWYgX_RYlE7H15CKBwg1p94u2W_JXLho4SfEhC4_tHXZZATxbYymk4mPkqJGhRSpoiXvVKvaozNd58bzu066fU5hA"
    expect(@expected["data"]["attributes"]["photo"]).to eq(test)
  end

  it 'handles not finding a background image' do
    place_response = File.read('spec/fixtures/photo_service/plainfield_oh.json')
    stub_request(:get, "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=photos&input=Plainfield,%20OH&inputtype=textquery&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                .to_return(status: 200, body: place_response, headers: {})

    get '/api/v1/backgrounds?location=Plainfield, OH'
    @expected = JSON.parse(response.body)

    test = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1080&key=#{ENV['GOOGLE_GEOCODING_KEY']}&photoreference="
    expect(@expected["data"]["attributes"]["photo"]).to eq(test)
  end
end
