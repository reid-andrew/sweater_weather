class OpenWeatherService
  class << self
    include Parseable

    def find_weather(coordinates)
      parse_json(connection(coordinates))
    end

    private

    def connection(coordinates)
      url = 'https://api.openweathermap.org/data/2.5/onecall'
      Faraday.get(url) do |req|
        req.params['lat'] = coordinates[:lat]
        req.params['lon'] = coordinates[:lng]
        req.params['exclude'] = 'minutely'
        req.params['units'] = 'imperial'
        req.params['appid'] = ENV['OPEN_WEATHER_KEY']
      end
    end
  end
end
