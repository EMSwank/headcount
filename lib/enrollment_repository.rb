require 'CSV'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(symbols)
      data = symbols[:enrollment][:kindergarten]
      source = CSV.open(data, {headers: true, header_converters: :symbol})
      @enrollments = get_enrollments(source)
      uniq_enrollments
      # add_enrollments(source)
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

  def add_enrollments(source)
    data = CSV.open(source, {headers: true, header_converters: :symbol})
    data.each do |row|
      parse_rows(row)
      match_names(row)
      @enrollments[match_names].kindergarten_participation[row[:timeframe]] =
                                                           row[:data]
      end
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
