require 'CSV'
require_relative 'district'

class DistrictRepository

  attr_reader :districts

  def load_data(symbols)
      enrollment = symbols[:enrollment]
      data = enrollment[:kindergarten]
      contents = CSV.open(data, {headers: true, header_converters: :symbol})
      @districts = contents.map do |row|
        row[:name] = row[:location]
        District.new(row)
      end
      return contents
  end

  def find_by_name(name)
    @districts.find do |district|
      district.name == name
    end
  end
end
