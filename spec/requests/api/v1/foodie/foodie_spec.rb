# require 'rails_helper'
#
# RSpec.describe 'Foodie Endpoint -', type: :request do
#   before(:each) do
#     geocode_json_response = File.read('spec/fixtures/geocoding_service/pueblo_co.json')
#     stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=pueblo,co&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
#                 .to_return(status: 200, body: geocode_json_response, headers: {})
#
#     weather_json_response = File.read('spec/fixtures/open_weather_service/pueblo_co.json')
#     stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=38.2544472&lon=-104.6091409&units=imperial")
#                 .to_return(status: 200, body: weather_json_response, headers: {})
#
#     zomato_json_response = File.read('spec/fixtures/foodie_service/pueblo_italian.json')
#     stub_request(:get, "https://developers.zomato.com/api/v2.1/search?lat=38.2544472&lon=-104.6091409&q=italian")
#                 .to_return(status: 200, body: zomato_json_response, headers: {})
#
#     directions_json_response = File.read('spec/fixtures/directions/denver_to_pueblo.json')
#     stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?destination=pueblo,co&key=#{ENV['GOOGLE_GEOCODING_KEY']}&origin=denver,co")
#                 .to_return(status: 200, body: directions_json_response, headers: {})
#   end
#
#   it 'gets food info for a given location' do
#     get '/api/v1/foodie?start=denver,co&end=pueblo,co&search=italian'
#     json_response = JSON.parse(response.body, symbolize_names: true)
#     expected = json_response[:data]
#
#     expect(response).to be_successful
#     expect(response.status).to eq(200)
#     expect(expected[:type]).to eq('foodie')
#     expect(expected[:attributes][:end_location]).to eq('pueblo,co')
#     expect(expected[:attributes][:travel_time]).to eq('1 hour 48 mins')
#     expect(expected[:attributes][:forecast][:summary]).to eq('clear sky')
#     expect(expected[:attributes][:forecast][:temperature]).to eq(52.32)
#     expect(expected[:attributes][:restaurant][:name]).to eq("Angelo's Pizza Parlor")
#     expect(expected[:attributes][:restaurant][:address]).to eq('105 E Riverwalk, Pueblo 81003')
#   end
# end
