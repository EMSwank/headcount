require 'CSV'
require_relative 'district'

class DistrictRepository

  attr_reader :districts

  def load_data(symbols)
      enrollment = symbols[:enrollment]
      data = enrollment[:kindergarten]
      source = CSV.open(data, {headers: true, header_converters: :symbol})
      @districts = source.map do |row|
        row[:name] = row[:location]
        District.new(row)
      end
      return source
  end

  def find_by_name(name)
    @districts.find do |district|
      district.name == name
    end
  end

  def find_all_matching(text)
    district_match = @districts.map {|district| district.name.upcase}
    district_match.uniq.grep(/#{text.upcase}/)
  end
end
