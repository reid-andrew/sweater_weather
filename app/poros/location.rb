class Location
  def self.location(location, geocode)
    location_information = []
    location_information << Location.new(location, geocode)
  end

  def initialize(location, geocode)
    @city = location.gsub(/,.*/, '').capitalize
    @state = location.gsub(/.*,/, '').gsub(' ', '').upcase
    @country = geocode[:results][0][:address_components][3][:long_name]
  end
end
