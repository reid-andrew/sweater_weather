class BackgroundPhoto
  attr_reader :id, :photo

  def initialize(param)
    require "pry"; binding.pry
    @param = param
  end

  def photo
    {}
  end
end
