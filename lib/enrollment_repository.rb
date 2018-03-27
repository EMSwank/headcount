require 'CSV'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def load_data(categories)
      @kinder_data = categories[:enrollment][:kindergarten]
      @hs_data = categories[:enrollment][:high_school_graduation]
      kinder_source = CSV.open(@kinder_data, {headers: true,
                                              header_converters: :symbol})
      @enrollments = get_enrollments(kinder_source)
      uniq_enrollments
      kinder_participation_data
      if !@hs_data.nil?
        hs_participation_data
      end
      enrollments
  end

  def get_enrollments(source)
    source.map do |row|
      parse_rows(row)
      Enrollment.new(:name => row[:name])
    end
  end

  def parse_rows(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    row[:data] = row[:data].to_f
  end

  def kinder_participation_data
    source = CSV.open(@kinder_data, {headers: true, header_converters: :symbol})
    source.each do |row|
      parse_rows(row)
      key = match_names(row)
      enrollments[key].kindergarten_participation[row[:timeframe]] =
                                                  row[:data]
      end
    enrollments
  end

  def hs_participation_data
    source = CSV.open(@hs_data, {headers: true, header_converters: :symbol})
    source.each do |row|
      parse_rows(row)
      key = match_names(row)
      enrollments[key].high_school_graduation_rates[row[:timeframe]] =
                                                    row[:data]
      end
    enrollments
  end

  def match_names(row)
    @enrollments.find_index do |enrollment|
      enrollment.name == row[:location].upcase
    end
  end

  def find_by_name(district_name)
    @enrollments.find do |enrollment|
      enrollment.name == district_name
    end
  end

  def uniq_enrollments
    @enrollments.uniq! {|enrollment| enrollment.name}
  end

end
