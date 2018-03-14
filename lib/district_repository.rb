require 'CSV'
require './lib/district'

class DistrictRepository

  def initialize
    @districts = []
  end

  def load_data(file)
    CSV.open(file, headers: true, header_converters: :symbol)
  end

  def find_by_name(district)
    binding.pry
    @districts.find do |district|
      district.name == name
    end
  end
end
