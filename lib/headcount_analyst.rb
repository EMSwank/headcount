require_relative 'district_repository'
require_relative 'general_calculations'

class HeadcountAnalyst
  include GeneralCalculations

  attr_reader :dr

  def initialize(dr)
    @dr = dr
    district_correlations
  end

  def average_kindergarten_participation(district_name)
    district = @dr.districts.find {|district| district.name == district_name}
    total = district.enrollment.kindergarten_participation_by_year
                               .reduce(0) {|sum, percent| sum + percent[1]}
    avg = total / district.enrollment.kindergarten_participation_by_year.length
    truncate_to_three_decimals(avg)
  end

  def kindergarten_participation_rate_variation(name, symbol)
    dist_1 = average_kindergarten_participation(name)
    dist_2 = average_kindergarten_participation(symbol[:against])
    rate_variation = dist_1 / dist_2
    truncate_to_three_decimals(rate_variation)
  end

  def kindergarten_participation_rate_variation_trend(name, symbol)
    dist_name_1 = @dr.find_by_name(name)
    year_set_1 = dist_name_1.enrollment.kindergarten_participation_by_year
    dist_name_2 = @dr.find_by_name(symbol[:against])
    year_set_2 = dist_name_2.enrollment.kindergarten_participation_by_year
    trends = year_set_1.merge(year_set_2) do |key, oldval, newval|
      result = oldval / newval
      truncate_to_three_decimals(result)
    end
  end

  def average_district_graduation_rate(district_name)
    district = @dr.districts.find {|district| district.name == district_name}
    total = district.enrollment.graduation_rate_by_year
                               .reduce(0) {|sum, percent| sum + percent[1]}
    total_length = district.enrollment.graduation_rate_by_year.length
    total_length == 0 ? total_length = 1 : total_length
    avg = total / total_length
    truncate_to_three_decimals(avg)
  end

  def graduation_rate_variation(name, symbol)
    dist_1 = average_district_graduation_rate(name)
    dist_2 = average_district_graduation_rate(symbol[:against])
    dist_2 == 0 ? dist_2 = 1: dist_2
    rate_variation = dist_1 / dist_2
    truncate_to_three_decimals(rate_variation)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    num = kindergarten_participation_rate_variation(district,
                                                    :against => 'COLORADO')/
          graduation_rate_variation(district, :against => 'COLORADO')
    num.round(3)
  end

  def correlation?(variation)
    variation > 0.6 && variation < 1.5 ? true : false
  end

  def district_correlations
    @correlations = {}
    @dr.districts.each do |district|
      if district.name == 'COLORADO'
        next
      end
        variation =
        kindergarten_participation_against_high_school_graduation(district.name)
        @correlations[district.name] = variation
    end
  end

  def district_correlation?(district)
    correlation?(@correlations[district])
  end

  def state_correlation?
    values = @correlations.values
      correlation_values = []
      values.map do |value|
        if correlation?(value) == true
          correlation_values << value
        end
      end
      if correlation_values.length.to_f / values.length.to_f > 0.7
        return true
      else
        return false
      end
  end

  def across_correlation?(districts)
      true_districts = []
      districts.each do |district|
        if district_correlation?(district) == true
          true_districts << district
        end
      end
      correlation = true_districts.length.to_f / districts.length.to_f
      correlation?(correlation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(symbol)
    if symbol[:for] == 'STATEWIDE'
      state_correlation?
    elsif symbol[:for]
      district_correlation?(symbol[:for])
    else symbol[:across]
      across_correlation?(symbol[:across])
    end
  end

  def top_statewide_test_year_over_year_growth(params)
    available_grades = [3, 8]
    raise InsufficientInformationError if !params.include?(:grade)
    raise UnknownDataError if !available_grades.include?(params[:grade])
    load_top_third_grade_growth
    # @third_growth = {}
    # @dr.districts.each do |district|
    #   math_result = []
    #   reading_result = []
    #   writing_result = []
    #   scores = district.statewide_test.third_grade
    #   scores.each_pair do |year|
    #     math_result << year[1][:math]
    #     reading_result << year[1][:reading]
    #     writing_result << year[1][:writing]
    #   end
    #   avg_math = (math_result.reduce(:+) / math_result.length)
    #   avg_math = truncate_to_three_decimals(avg_math)
    #   avg_read = (reading_result.reduce(:+) / reading_result.length)
    #   avg_read = truncate_to_three_decimals(avg_read)
    #   avg_write = (writing_result.reduce(:+) / math_result.length)
    #   avg_write = truncate_to_three_decimals(avg_write)
    #   @third_growth[district.name] = {:math => avg_math,
    #                                   :reading => avg_read,
    #                                   :writing => avg_write}
    end


  end

  def load_top_third_grade_growth
    @third_growth = {}
    @dr.districts.each do |district|
      math_result = []
      reading_result = []
      writing_result = []
      scores = district.statewide_test.third_grade
      scores.each_pair do |year|
        @third_growth.merge(year[1]) do |key, oldval, newval|
          require 'pry'; binding.pry
          if oldval.class != Float
            oldval = 0
          else
            newval = [oldval, newval]
          end
          newval.flatten
        end
        if !year[1][:math].is_a?(Float)
          math_result << 0
        else
          math_result << year[1][:math]
        end
        if !year[1][:reading].is_a?(Float)
          reading_result << 0
        else
          reading_result << year[1][:reading]
        end
        if !year[1][:writing].is_a?(Float)
          writing_result << 0
        else
          writing_result << year[1][:writing]
        end
      end

    avg_math = (math_result.reduce(:+) / math_result.length)
      # avg_math = truncate_to_three_decimals(avg_math)
    avg_read = (reading_result.reduce(:+) / reading_result.length)
      # avg_read = truncate_to_three_decimals(avg_read)
    avg_write = (writing_result.reduce(:+) / writing_result.length)
      # avg_write = truncate_to_three_decimals(avg_write)
    @third_growth[district.name] = {
                               :math => truncate_to_three_decimals(avg_math),
                               :reading => truncate_to_three_decimals(avg_read),
                               :writing => truncate_to_three_decimals(avg_write)
                                     }

  end
end
