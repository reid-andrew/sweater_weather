class Foodie
  attr_reader :id,
              :end_location,
              :travel_time,
              :forecast,
              :restaurant

  def initialize(args)
    @id = "#{args[:search]} food in #{args[:end]}"
    @end_location = args[:end]
    @travel_time = find_duration(args[:start], args[:end])[:text]
    @forecast = find_forecast(args[:end],
                arrival(find_duration(args[:start], args[:end])[:int]))
    @restaurant = find_restaurant(geocode(args[:end]), args[:search])
  end

  private

  def arrival(duration)
    Time.now + duration
  end

  def geocode(destination)
    GeocodingService.find_geocode(destination)
  end

  def find_duration(origin, destination)
    directions = DirectionService.find_distance(origin, destination)
    {
      text: directions[:routes][0][:legs][0][:duration][:text],
      int: directions[:routes][0][:legs][0][:duration][:value]
    }
  end

  def find_restaurant(geocode, search)
    location = geocode[:results][0][:geometry][:location]
    FoodieService.find_restaurant(location[:lat],
                                  location[:lng],
                                  search)
  end

  def find_forecast(destination, time = Time.now)
    {
      summary: weather(destination, time)[:weather][0][:description],
      temperature: weather(destination, time)[:temp]
    }
  end

  def weather(destination, time)
    report = WeatherReport.new(destination)
    weather_closest_to_arrival_time(report, time)
  end

  def weather_closest_to_arrival_time(report, time)
    forecasts = weather_after_scheduled_arrival(report, time)
    forecasts.max_by { |x| x[:dt] }
  end

  def weather_after_scheduled_arrival(report, time)
    report.weather_data[:hourly].select { |hour| hour[:dt] > time.to_i }
  end
end
