class Foodie
  attr_reader :id

  def initialize(params)
    @id = "x"
    @geocode = GeocodingService.find_geocode(params[:end])
    @end_location = params[:end]
    @travel_time = ''
    @forecast = forecast(params[:end], date = Time.now)
    @restaurant = ''
  end

  private

  def forecast(destination, time)
    {
      summary: weather(destination, time)[:weather][0][:description],
      temperature: weather(destination, time)[:temp]
    }
  end

  def weather(destination, time)
    report = WeatherReport.new(destination)
    get_weather(report, time)
  end

  def get_weather(report, time)
    after = report.weather_data[:hourly].select { |hour| hour[:dt] > time.to_i }
    after.max_by { |x| x[:dt] }
  end
end
