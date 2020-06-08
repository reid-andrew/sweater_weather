class Foodie
  attr_reader :id

  def initialize(params)
    @id = "x"
    @geocode = GeocodingService.find_geocode(params[:end])
    @end_location = params[:end]
    @travel_time = ''
    @forecast = forecast(params[:end], date = Time.now)
    @restaurant = get_restaurant(@geocode, params[:search])
  end

  private

  def get_restaurant(geocode, search)
    location = geocode[:results][0][:geometry][:location]
    FoodieService.find_restaurant(location[:lat],
                                  location[:lng],
                                  search)
  end

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
