require 'CSV'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(symbols)
      data = symbols[:enrollment][:kindergarten]
      source = CSV.open(data, {headers: true, header_converters: :symbol})
      @enrollments = source.map do |row|
        row[:name] = row[:location]
        Enrollment.new(row)
      end
      return source
  end

  def find_by_name(name)
    @enrollments.find do |enrollment|
      enrollment.name.upcase == name.upcase
    end
  end

end
