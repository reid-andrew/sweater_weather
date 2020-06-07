class WeatherReportSerializer
  include FastJsonapi::ObjectSerializer
  attributes :weather
end
