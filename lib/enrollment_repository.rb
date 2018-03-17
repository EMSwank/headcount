require 'CSV'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(symbols)
      @data = symbols[:enrollment][:kindergarten]
      source = CSV.open(@data, {headers: true, header_converters: :symbol})
      @enrollments = get_enrollments(source)
      uniq_enrollments
      participation_data
  end

  def get_enrollments(source)
    source.map do |row|
      parse_rows(row)
      Enrollment.new(:name => row[:name],
                     :kindergarten_participation =>
                      {row[:timeframe] => row[:data]}
                    )
    end
  end

  def parse_rows(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    row[:data] = row[:data]
  end

  def participation_data
    source = CSV.open(@data, {headers: true, header_converters: :symbol})
    source.each do |row|
      parse_rows(row)
      key = match_names(row)
      @enrollments[key].kindergarten_participation[row[:timeframe]] =
                                                           row[:data]
      end
      binding.pry
    @enrollments
  end

  def match_names(row)
    @enrollments.find_index do |enrollment|
      enrollment.name == row[:location].upcase
    end
  end

  def find_by_name(name)
    @enrollments.find do |enrollment|
      enrollment.name.upcase == name.upcase
    end
  end

  def uniq_enrollments
    @enrollments.uniq {|enrollment| enrollment.name}
  end

end
