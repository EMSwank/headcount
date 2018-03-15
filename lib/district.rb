class District

  attr_reader :name

  def initialize(data)
    @name = data[:location]
  end
end
