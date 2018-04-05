require 'CSV'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'general_calculations'

class DistrictRepository
  include GeneralCalculations

  attr_reader :districts,
              :enrollments

  def load_data(symbols)
    data = symbols[:enrollment][:kindergarten]
    parse_data(data)
    if symbols[:enrollment]
      er = EnrollmentRepository.new
      er.load_data(symbols)
      @enrollments = er.load_data(symbols)
      add_enrollment
    end
    if symbols[:statewide_testing]
      str = StatewideTestRepository.new
      @statewide_tests = str.load_data(symbols)
      add_statewide_tests
    end
  end

  def parse_data(data)
    source = get_data(data)
    @districts = source.map do |row|
      row[:name] = row[:location].upcase
      District.new(row)
    end
    @districts.uniq! {|district| district.name}
  end

  def add_enrollment
    @districts.each_with_index do |district, index|
      district.enrollment = @enrollments[index]
    end
  end

  def add_statewide_tests
    @districts.each_with_index do |district, index|
      district.statewide_test = @statewide_tests[index]
    end
  end

  def find_by_name(district_name)
    districts.find do |district|
      district.name == district_name
    end
  end

  def find_all_matching(text)
    district_match = @districts.map {|district| district.name.upcase}
    district_match.uniq.grep(/#{text.upcase}/)
  end
end
