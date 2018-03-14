require 'CSV'
require './lib/district'

class DistrictRepository

  def initialize
    @districts = []
  end

  def load_data(file)
    CSV.foreach(file, headers: true, header_converters: :symbol) do |data|
      # puts data
      @districts << District.new(data)
    end
  end

  def find_by_name(district)
    binding.pry
    @districts.find do |district|
      district.name == name
    end
  end
end
