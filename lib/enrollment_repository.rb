require 'CSV'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(symbols)
      enrollment = symbols[:enrollment]
      data = enrollment[:kindergarten]
      contents = CSV.open(data, {headers: true, header_converters: :symbol})
      @enrollments = contents.map do |row|
        row[:name] = row[:location]
        Enrollment.new(row)
      end
      return contents
  end

end
