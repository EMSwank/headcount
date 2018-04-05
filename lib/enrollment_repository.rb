require 'CSV'
require_relative 'enrollment'
require_relative 'general_calculations'

class EnrollmentRepository
  include GeneralCalculations

  attr_reader :enrollments

  def load_data(categories)
      @kinder_data = categories[:enrollment][:kindergarten]
      @hs_data = categories[:enrollment][:high_school_graduation]
      kinder_source = get_data(@kinder_data)
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
      parse_rows_enrollment(row)
      Enrollment.new(:name => row[:name])
    end
  end

  def kinder_participation_data
    source = get_data(@kinder_data)
    source.each do |row|
      parse_rows_enrollment(row)
      key = match_names(row)
      enrollments[key].kindergarten_participation[row[:timeframe]] = row[:data]
      end
    enrollments
  end

  def hs_participation_data
    source = get_data(@hs_data)
    source.each do |row|
      parse_rows_enrollment(row)
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
