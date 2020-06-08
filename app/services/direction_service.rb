class DirectionService
  class << self
    include Parseable

    def find_directions(origin, destination)
      parse_json(connection(origin, destination))
    end

    private

    def connection(origin, destination)
      url = 'https://maps.googleapis.com/maps/api/directions/json'
      Faraday.get(url) do |req|
        req.params['address'] = address.gsub(' ', '+')
        req.params['key'] = ENV['GOOGLE_GEOCODING_KEY']
      end
    end
  end
end
