require 'CSV'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(symbols)
      data = symbols[:enrollment][:kindergarten]
      source = CSV.open(data, {headers: true, header_converters: :symbol})
      @enrollments = get_enrollments(source)
      collate_years
  end

  def get_enrollments(source)
    source.map do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:data] = row[:data]
      Enrollment.new(:name => row[:name],
                     :kindergarten_participation =>
                      {row[:timeframe] => row[:data]}
                    )
    end
  end

  def find_by_name(name)
    @enrollments.find do |enrollment|
      enrollment.name.upcase == name.upcase
    end
  end

  def get_uniq_districts
    @enrollments.uniq {|enrollment| enrollment.name}
  end

  def add_years
    @enrollments.map do |enrollment|
      binding.pry
      get_uniq_districts.map do |enroll|
      if enrollment.name == enroll.name
        end
      end
    end
  end

end
