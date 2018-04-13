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
    if params[:grade] == 3
      load_top_third_grade_growth(params)
    elsif params[:grade] == 8
      load_top_eight_grade_growth(params)
    elsif params[:weighting] && params[:subject] == nil
      load_top_district_average
    end
  end

  def load_top_third_grade_growth(params)
    @third_growth = {}
    @dr.districts.each do |district|
      raw_scores = district.statewide_test.third_grade.to_a
      subject_scores = []
      scores = get_subject_scores(params, raw_scores, subject_scores, district)
      normalize_scores(params, scores, subject_scores)
      get_year_difference(params, scores, subject_scores, district)
    end
    rank_district_growth(params)
  end

  def load_top_eight_grade_growth(params)
    @eighth_growth = {}
    @dr.districts.each do |district|
      raw_scores = district.statewide_test.eighth_grade.to_a
      subject_scores = []
      scores = get_subject_scores(params, raw_scores, subject_scores, district)
      normalize_scores(params, scores, subject_scores)
      get_year_difference(params, scores, subject_scores, district)
    end
    rank_district_growth(params)
  end

  def load_top_district_average(params)
    if params[:grade] == 3
      load_top_third_grade_growth(subject: math)
      load_top_third_grade_growth(subject: reading)
      load_top_third_grade_growth(subject: writing)
      require 'pry'; binding.pry

    end
  end

  def normalize_scores(params, scores, subject_scores)
    scores.delete_if {|score| score[1][params[:subject]].is_a?(String)}
    scores.delete_if {|score| score[1][params[:subject]] == 0.0}
    subject_scores.delete_if {|score| score[1].is_a?(String)}
    subject_scores.delete_if {|score| score[1] == 0.0}
  end

  def get_subject_scores(params, raw_scores, subject_scores, district)
    raw_scores.each do |score|
      subject_scores << [district.name, score[1][params[:subject]]]
    end
  end

  def get_year_difference(params, scores, subject_scores, district)
    if !scores.empty? || scores.length > 1
      high_year = scores.max[0]
      low_year = scores.min[0]
      if !subject_scores.empty? || !subject_scores.nil? ||
         subject_scores.length > 1
        unless high_year.nil? || low_year.nil?
          year_difference = high_year - low_year
          growth = (subject_scores.max[1] - subject_scores.min[1]) / year_difference
        end
        add_growth(params, year_difference, district, growth)
      end
    end
  end

  def add_growth(params, year_difference, district, growth)
    if params[:grade] == 3
      unless year_difference == 0
      @third_growth[district.name] = {params[:subject] =>
                                      truncate_to_three_decimals(growth)}
      end
    elsif params[:grade] == 8
      unless year_difference == 0
      @eighth_growth[district.name] = {params[:subject] => truncate_to_three_decimals(growth)}
      end
    end

  end

  def rank_district_growth(params)
    growth = []
    if params[:grade] == 3
      pairs = @third_growth.to_a
    elsif params[:grade] == 8
      pairs = @eighth_growth.to_a
    end
    pairs.each {|pair| growth << [pair[0], pair[1][params[:subject]]]}
    ordered_scores = growth.sort_by {|district, growth| growth}.reverse
    if params[:top]
      ordered_scores[0..(params[:top] - 1)]
    else
      ordered_scores[0]
    end
  end
end
