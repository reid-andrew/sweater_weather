class Foodie
  attr_reader :id,
              :end_location,
              :travel_time,
              :forecast,
              :restaurant

  def initialize(foodie_params)
    trip_time = find_travel_time(foodie_params[:start], foodie_params[:end])
    @id = "#{foodie_params[:search]} food in #{foodie_params[:end]}"
    @end_location = foodie_params[:end]
    @travel_time = trip_time[:text]
    @forecast = find_forecast(foodie_params[:end], arrival_time(trip_time[:int]))
    @restaurant = find_restaurant(geocode(foodie_params[:end]), foodie_params[:search])
  end

  private

  def arrival_time(duration)
    Time.now + duration
  end

  def geocode(destination)
    GeocodingService.find_geocode(destination)
  end

  def find_travel_time(origin, destination)
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
    find_weather(report, time)
  end

  def find_weather(report, time)
    after = report.weather_data[:hourly].select { |hour| hour[:dt] > time.to_i }
    after.max_by { |x| x[:dt] }
  end
end
