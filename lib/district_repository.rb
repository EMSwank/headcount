require 'CSV'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository

  attr_reader :districts,
              :enrollments

  def load_data(symbols)
    if symbols[:enrollment]
      er = EnrollmentRepository.new
      @enrollments = er.load_data(symbols)
    end
    data = symbols[:enrollment][:kindergarten]
    parse_district_data(data)
  end

  def parse_district_data(data)
    source = CSV.open(data, {headers: true, header_converters: :symbol})
    @districts = source.map do |row|
      row[:name] = row[:location].upcase
      District.new(row)
    end
    @districts.uniq! {|district| district.name}
    add_enrollment
  end

  def add_enrollment
    @districts.each_with_index do |district, index|
      district.enrollment = @enrollments[index]
    end
  end

  def find_by_name(name)
    @districts.find do |district|
      district.name == name.upcase
    end
  end

  def find_all_matching(text)
    matches = []
    # x = text.length
    # @districts.find_all do |district|
    #   district.name == text
    # end
    # district_match =
    @districts.map do |district|
      if district.name.include?(text)
      matches << district
      end
      binding.pry
     end
    # district_match.uniq.grep(/#{text.upcase}/)
  end
end
