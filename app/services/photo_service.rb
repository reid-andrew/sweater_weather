class PhotoService
  class << self
    include Parseable

    def find_photo(location)
      reference = find_photo_reference(location)
      base = 'https://maps.googleapis.com/maps/api/place/photo?'
      width = 'maxwidth=1080'
      key = "&key=#{ENV['GOOGLE_GEOCODING_KEY']}"
      photo = "&photoreference=#{reference}"
      "#{base}#{width}#{key}#{photo}"
    end

    def find_photo_reference(location)
      place = parse_json(connection(location))
      return nil if place[:candidates] == [{}]
      place[:candidates][0][:photos][0][:photo_reference]
    end

    private

    def connection(location)
      url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
      Faraday.get(url) do |req|
        req.params['input'] = location
        req.params['key'] = ENV['GOOGLE_GEOCODING_KEY']
        req.params['inputtype'] = 'textquery'
        req.params['fields'] = 'photos'
      end
    end
  end
end
