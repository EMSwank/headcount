require 'CSV'
require './lib/district'

class DistrictRepository

  attr_reader :districts

  def initialize
    @districts = []
  end

  def load_data(file)
    contents = CSV.open(file, headers: true, header_converters: :symbol)
      # binding.pry
    @districts = contents.map do |row|
      District.new(row)
    end
    districts.uniq! {|district| district.name}
  end

  def find_by_name(name)
    binding.pry
    @districts.find do |district|
      district.name == name
    end
  end
end
