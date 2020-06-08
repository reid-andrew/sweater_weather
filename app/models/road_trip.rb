class RoadTrip < ApplicationRecord
  validates :origin, presence: true
  validates :destination, presence: true
  validates :travel_time, presence: true
  validates :forecast_temp, presence: true
  validates :forecast_description, presence: true
  validates :trip_date, presence: true

  belongs_to :user

  def self.create_road_trip(origin, destination, user, date = Time.now)
    time_early = DateTime.new(date.year, date.month, date.day, 0, 0, 0, 0).to_time.to_i
    time_late = DateTime.new(date.year, date.month, date.day, 24, 0, 0, 0).to_time.to_i
    report = WeatherReport.new(destination)
    weather = report.weather_data[:daily].select{|day| day[:dt] >= time_early && day[:dt] < time_late}

    RoadTrip.create(
      origin: origin,
      destination: destination,
      travel_time: "5",
      forecast_temp: weather[0][:temp][:day],
      forecast_description: weather[0][:weather][0][:description],
      trip_date: date,
      user: user
    )
  end
end
