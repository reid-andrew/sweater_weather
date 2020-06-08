class RoadTrip < ApplicationRecord
  validates :origin, presence: true
  validates :destination, presence: true
  validates :travel_time, presence: true
  validates :forecast_temp, presence: true
  validates :forecast_description, presence: true
  validates :trip_date, presence: true

  belongs_to :user

  class << self
    def create_road_trip(origin, destination, user, date = Time.now)
      report = WeatherReport.new(destination)
      weather = get_weather(report, date + find_duration(origin, destination)[:int])
      save_trip(origin, destination, user, date, weather)
    end

    private

    def find_duration(origin, destination)
      directions = DirectionService.find_distance(origin, destination)
      {
        text: directions[:routes][0][:legs][0][:duration][:text],
        int: directions[:routes][0][:legs][0][:duration][:value]
      }
    end

    def get_weather(report, date)
      report.weather_data[:daily].select do |day|
        day[:dt] >= time_early(date) && day[:dt] < time_late(date)
      end
    end

    def time_early(date)
      DateTime.new(date.year, date.month, date.day, 0, 0, 0, 0).to_time.to_i
    end

    def time_late(date)
      DateTime.new(date.year, date.month, date.day, 24, 0, 0, 0).to_time.to_i
    end

    def save_trip(origin, destination, user, date, weather)
      RoadTrip.create(
        origin: origin,
        destination: destination,
        travel_time: find_duration(origin, destination)[:text],
        forecast_temp: weather[0][:temp][:day],
        forecast_description: weather[0][:weather][0][:description],
        trip_date: date,
        user: user
      )
    end
  end
end
