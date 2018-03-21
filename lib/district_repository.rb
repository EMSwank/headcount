require 'CSV'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository

  attr_reader :districts,
              :enrollments

  def load_data(symbols)
    if symbols[:enrollment]
      er = EnrollmentRepository.new
      er.load_data(symbols)
      @enrollments = er.load_data(symbols)
    end
    data = symbols[:enrollment][:kindergarten]
    parse_data(data)
  end

  def parse_data(data)
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
      district.name == name
    end
  end

  def find_all_matching(text)
    index = text.length - 1
    @districts.find_all do |district|
      district.name[0..index] == name[0..index]
    end
    # district_match = @districts.map {|district| district.name.upcase}
    # district_match.uniq.grep(/#{text.upcase}/)
  end
end
