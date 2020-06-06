class Location

  def initialize(location, geocode)
    @location = location
    @geocode = geocode
  end

  def city
    @location.gsub(/,.*/, '').capitalize
  end

  def state
    @location.gsub(/.*,/, '').gsub(' ', '').upcase
  end

  def country
    @geocode[:results][0][:address_components][3][:long_name]
  end
end
