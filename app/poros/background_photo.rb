class BackgroundPhoto
  attr_reader :id

  def initialize(location)
    @id = location
    @photo_link = PhotoService.find_photo(location)
  end

  def photo
    @photo_link
  end
end
