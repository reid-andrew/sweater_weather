class Foodie
  attr_reader :id,
              :end_location,
              :travel_time,
              :forecast,
              :restaurant

  def initialize(params)
    @id = "#{params[:search]} food in #{params[:end]}"
    @geocode = GeocodingService.find_geocode(params[:end])
    @end_location = params[:end]
    @travel_time = find_travel_time(params[:start], params[:end])
    @forecast = find_forecast(params[:end], date = Time.now)
    @restaurant = find_restaurant(@geocode, params[:search])
  end

  private

  def foodie_params
    params.permit(:search, :start, :end)
  end

  def find_travel_time(origin, destination)
    directions = DirectionService.find_distance(origin, destination)
    directions[:routes][0][:legs][0][:duration][:text]
  end

  def find_restaurant(geocode, search)
    location = geocode[:results][0][:geometry][:location]
    FoodieService.find_restaurant(location[:lat],
                                  location[:lng],
                                  search)
  end

  def find_forecast(destination, time)
    {
      summary: weather(destination, time)[:weather][0][:description],
      temperature: weather(destination, time)[:temp]
    }
  end

  def weather(destination, time)
    report = WeatherReport.new(destination)
    find_weather(report, time)
  end

  def find_weather(report, time)
    after = report.weather_data[:hourly].select { |hour| hour[:dt] > time.to_i }
    after.max_by { |x| x[:dt] }
  end
end
