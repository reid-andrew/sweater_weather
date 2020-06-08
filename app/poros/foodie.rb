class Foodie
  def initialize(params)
    @geocode = GeocodingService.find_geocode(params[:end])
    @end_location = params[:end]
    @travel_time = ''
    @forecast = weather(params[:end], date = Time.now)
    @restaurant = ''
  end

  def weather(destination, date)
    report = WeatherReport.new(destination)
    get_weather(report, date)
  end

  def get_weather(report, date)
    after = report.weather_data[:hourly].select { |hour| hour[:dt] > date.to_i }
    after.max_by { |x| x[:dt] }
  end

  # def time_early(date)
  #   DateTime.new(date.year, date.month, date.day, 0, 0, 0, 0).to_time.to_i
  # end
  #
  # def time_late(date)
  #   DateTime.new(date.year, date.month, date.day, 24, 0, 0, 0).to_time.to_i
  # end
end
