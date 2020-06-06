require 'rails_helper'

RSpec.describe 'Forecast Endpoint -', type: :request do
  before(:each) do
    json_response = File.read('spec/fixtures/geocoding_service/cleveland_oh.json')
    stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=cleveland,%2Boh&key=#{ENV['GOOGLE_GEOCODING_KEY']}")
                .to_return(status: 200, body: json_response, headers: {})

    json_response = File.read('spec/fixtures/open_weather_service/cleveland_oh.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['OPEN_WEATHER_KEY']}&exclude=minutely&lat=41.49932&lon=-81.6943605&units=imperial")
                .to_return(status: 200, body: json_response, headers: {})

    weather_fixture = File.read('spec/fixtures/open_weather_service/cleveland_oh.json')
    @weather = JSON.parse(weather_fixture, symbolize_names: true)

    geocode_fixture = File.read('spec/fixtures/geocoding_service/cleveland_oh.json')
    @geocode = JSON.parse(geocode_fixture, symbolize_names: true)

    get '/api/v1/forecast?location=cleveland, oh'
    @expected = JSON.parse(response.body)
  end

  it 'responds with success' do
    expect(response).to be_successful
    expect(@expected["data"]["id"]).to eq("cleveland, oh - #{@weather[:current][:dt]}")
  end

  it 'provides location information for a city' do
    expect(@expected["data"]["attributes"]["location"]["city"]).to eq(@geocode[:results][0][:address_components][0][:long_name])
    expect(@expected["data"]["attributes"]["location"]["state"]).to eq(@geocode[:results][0][:address_components][2][:short_name])
    expect(@expected["data"]["attributes"]["location"]["country"]).to eq(@geocode[:results][0][:address_components][3][:long_name])
  end

  it 'provides current_weather for a city' do
    expect(@expected["data"]["attributes"]["current_weather"]["time"]).to eq(Time.at(@weather[:current][:dt]).strftime('%l:%M %p, %B%e'))
    expect(@expected["data"]["attributes"]["current_weather"]["current_temp"]).to eq(@weather[:current][:temp])
    expect(@expected["data"]["attributes"]["current_weather"]["high"]).to eq(@weather[:daily][0][:temp][:max])
    expect(@expected["data"]["attributes"]["current_weather"]["low"]).to eq(@weather[:daily][0][:temp][:min])
    expect(@expected["data"]["attributes"]["current_weather"]["description"]).to eq(@weather[:current][:weather][0][:description])
    expect(@expected["data"]["attributes"]["current_weather"]["image"]).to eq("http://openweathermap.org/img/wn/#{@weather[:current][:weather][0][:icon]}@2x.png")
  end

  it 'provides current_details for a city' do
    expect(@expected["data"]["attributes"]["current_details"]["description"]).to eq(@weather[:current][:weather][0][:description])
    expect(@expected["data"]["attributes"]["current_details"]["image"]).to eq("http://openweathermap.org/img/wn/#{@weather[:current][:weather][0][:icon]}@2x.png")
    expect(@expected["data"]["attributes"]["current_details"]["humidity"]).to eq(@weather[:current][:humidity])
    expect(@expected["data"]["attributes"]["current_details"]["visibility"]).to eq(@weather[:current][:visibility])
    expect(@expected["data"]["attributes"]["current_details"]["uv_index"]).to eq(@weather[:current][:uvi])
    expect(@expected["data"]["attributes"]["current_details"]["sunrise"]).to eq(Time.at(@weather[:current][:sunrise]).strftime('%l:%M %p'))
    expect(@expected["data"]["attributes"]["current_details"]["sunset"]).to eq(Time.at(@weather[:current][:sunset]).strftime('%l:%M %p'))
    expect(@expected["data"]["attributes"]["current_details"]["feels_like"]).to eq(@weather[:current][:feels_like])
  end

  it 'provides hourly forecast for today' do
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][0]["temp"]).to eq(@weather[:hourly][0][:temp])
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][0]["image"]).to eq(@weather[:hourly][0][:weather][0][:icon])
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][0]["time"]).to eq(Time.at(@weather[:hourly][0][:dt]).strftime('%l %p'))

    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][4]["temp"]).to eq(@weather[:hourly][4][:temp])
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][4]["image"]).to eq(@weather[:hourly][4][:weather][0][:icon])
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][4]["time"]).to eq(Time.at(@weather[:hourly][4][:dt]).strftime('%l %p'))

    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][7]["temp"]).to eq(@weather[:hourly][7][:temp])
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][7]["image"]).to eq(@weather[:hourly][7][:weather][0][:icon])
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][7]["time"]).to eq(Time.at(@weather[:hourly][7][:dt]).strftime('%l %p'))
  end

  it 'only provides 8 hours worth of hourly forecast' do
    expect(@expected["data"]["attributes"]["hourly_forecast"]["attributes"][8]).to eq(nil)
  end

  it 'provides daily forecast for the next 5 days' do
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][0]["day"]).to eq(Time.at(@weather[:daily][0][:dt]).strftime('%A'))
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][0]["description"]).to eq(@weather[:daily][0][:weather][0][:description])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][0]["image"]).to eq(@weather[:daily][0][:weather][0][:icon])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][0]["precipitation"]).to eq(0)
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][0]["high_temp"]).to eq(@weather[:daily][0][:temp][:max])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][0]["low_temp"]).to eq(@weather[:daily][0][:temp][:min])

    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][4]["day"]).to eq(Time.at(@weather[:daily][4][:dt]).strftime('%A'))
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][4]["description"]).to eq(@weather[:daily][4][:weather][0][:description])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][4]["image"]).to eq(@weather[:daily][4][:weather][0][:icon])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][4]["precipitation"]).to eq(@weather[:daily][4][:rain])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][4]["high_temp"]).to eq(@weather[:daily][4][:temp][:max])
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][4]["low_temp"]).to eq(@weather[:daily][4][:temp][:min])
  end

  it 'only provides 5 days worth of daily forecast' do
    expect(@expected["data"]["attributes"]["daily_forecast"]["attributes"][5]).to eq(nil)
  end
end
