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
    @output = JSON.parse(response.body)
    @expected = @output["data"]["attributes"]["weather"]
  end

  it 'responds with success' do
    expect(response).to be_successful
    expect(@output["data"]["id"]).to eq("cleveland, oh - #{@weather[:current][:dt]}")
  end

  it 'provides location information for a city' do
    expect(@expected["location"][0]["city"]).to eq(@geocode[:results][0][:address_components][0][:long_name])
    expect(@expected["location"][0]["state"]).to eq(@geocode[:results][0][:address_components][2][:short_name])
    expect(@expected["location"][0]["country"]).to eq(@geocode[:results][0][:address_components][3][:long_name])
  end

  it 'provides current_weather for a city' do
    expect(@expected["current_weather"][0]["time"]).to eq(Time.at(@weather[:current][:dt]).in_time_zone("America/New_York").strftime('%l:%M %p, %B%e'))
    expect(@expected["current_weather"][0]["current_temp"]).to eq(@weather[:current][:temp])
    expect(@expected["current_weather"][0]["high"]).to eq(@weather[:daily][0][:temp][:max])
    expect(@expected["current_weather"][0]["low"]).to eq(@weather[:daily][0][:temp][:min])
    expect(@expected["current_weather"][0]["description"]).to eq(@weather[:current][:weather][0][:description])
    expect(@expected["current_weather"][0]["image"]).to eq("http://openweathermap.org/img/wn/#{@weather[:current][:weather][0][:icon]}@2x.png")
  end

  it 'provides current_details for a city' do
    expect(@expected["current_details"][0]["description"]).to eq(@weather[:current][:weather][0][:description])
    expect(@expected["current_details"][0]["image"]).to eq("http://openweathermap.org/img/wn/#{@weather[:current][:weather][0][:icon]}@2x.png")
    expect(@expected["current_details"][0]["humidity"]).to eq(@weather[:current][:humidity])
    expect(@expected["current_details"][0]["visibility"]).to eq(@weather[:current][:visibility])
    expect(@expected["current_details"][0]["uv_index"]).to eq(@weather[:current][:uvi])
    expect(@expected["current_details"][0]["uv_index_interpreted"]).to eq('low')
    expect(@expected["current_details"][0]["sunrise"]).to eq(Time.at(@weather[:current][:sunrise]).in_time_zone("America/New_York").strftime('%l:%M %p'))
    expect(@expected["current_details"][0]["sunset"]).to eq(Time.at(@weather[:current][:sunset]).in_time_zone("America/New_York").strftime('%l:%M %p'))
    expect(@expected["current_details"][0]["feels_like"]).to eq(@weather[:current][:feels_like])
  end

  it 'provides hourly forecast for today' do
    expect(@expected["hourly_forecast"][0]["temp"]).to eq(@weather[:hourly][0][:temp])
    expect(@expected["hourly_forecast"][0]["image"]).to eq(@weather[:hourly][0][:weather][0][:icon])
    expect(@expected["hourly_forecast"][0]["time"]).to eq(Time.at(@weather[:hourly][0][:dt]).in_time_zone("America/New_York").strftime('%l %p'))

    expect(@expected["hourly_forecast"][4]["temp"]).to eq(@weather[:hourly][4][:temp])
    expect(@expected["hourly_forecast"][4]["image"]).to eq(@weather[:hourly][4][:weather][0][:icon])
    expect(@expected["hourly_forecast"][4]["time"]).to eq(Time.at(@weather[:hourly][4][:dt]).in_time_zone("America/New_York").strftime('%l %p'))

    expect(@expected["hourly_forecast"][7]["temp"]).to eq(@weather[:hourly][7][:temp])
    expect(@expected["hourly_forecast"][7]["image"]).to eq(@weather[:hourly][7][:weather][0][:icon])
    expect(@expected["hourly_forecast"][7]["time"]).to eq(Time.at(@weather[:hourly][7][:dt]).in_time_zone("America/New_York").strftime('%l %p'))
  end

  it 'only provides 8 hours worth of hourly forecast' do
    expect(@expected["hourly_forecast"][8]).to eq(nil)
  end

  it 'provides daily forecast for the next 5 days' do
    expect(@expected["daily_forecast"][0]["day"]).to eq(Time.at(@weather[:daily][0][:dt]).in_time_zone("America/New_York").strftime('%A'))
    expect(@expected["daily_forecast"][0]["description"]).to eq(@weather[:daily][0][:weather][0][:description])
    expect(@expected["daily_forecast"][0]["image"]).to eq("http://openweathermap.org/img/wn/#{@weather[:daily][0][:weather][0][:icon]}@2x.png")
    expect(@expected["daily_forecast"][0]["precipitation"]).to eq(0)
    expect(@expected["daily_forecast"][0]["high_temp"]).to eq(@weather[:daily][0][:temp][:max])
    expect(@expected["daily_forecast"][0]["low_temp"]).to eq(@weather[:daily][0][:temp][:min])

    expect(@expected["daily_forecast"][4]["day"]).to eq(Time.at(@weather[:daily][4][:dt]).in_time_zone("America/New_York").strftime('%A'))
    expect(@expected["daily_forecast"][4]["description"]).to eq(@weather[:daily][4][:weather][0][:description])
    expect(@expected["daily_forecast"][4]["image"]).to eq("http://openweathermap.org/img/wn/#{@weather[:daily][4][:weather][0][:icon]}@2x.png")
    expect(@expected["daily_forecast"][4]["precipitation"]).to eq(@weather[:daily][4][:rain])
    expect(@expected["daily_forecast"][4]["high_temp"]).to eq(@weather[:daily][4][:temp][:max])
    expect(@expected["daily_forecast"][4]["low_temp"]).to eq(@weather[:daily][4][:temp][:min])
  end

  it 'only provides 5 days worth of daily forecast' do
    expect(@expected["daily_forecast"][5]).to eq(nil)
  end
end
