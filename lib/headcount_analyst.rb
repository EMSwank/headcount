require_relative 'district_repository'

class HeadcountAnalyst

  attr_reader :dr

  def initialize(dr)
    @dr = dr
    district_correlations
  end

  def average_kindergarten_participation(district_name)
    district = @dr.find {|district| district.name == district_name}
    total =
      district.enrollment.kindergarten_participation_by_year
                         .reduce(0) do |sum, percent|
                           sum + percent[1]
                         end
    avg = total / district.enrollment.kindergarten_participation_by_year.length
    (avg.to_f*1000).floor/1000.0
  end

  def kindergarten_participation_rate_variation(name, symbol)
    dist_1 = average_kindergarten_participation(name)
    dist_2 = average_kindergarten_participation(symbol[:against])
    rate_variation = dist_1 / dist_2
    (rate_variation.to_f * 1000).floor/1000.0
  end

  def kindergarten_participation_rate_variation_trend(name, symbol)
    dist_name_1 = @dr.find {|district| district.name == name}
    year_set_1 = dist_name_1.enrollment.kindergarten_participation_by_year
    dist_name_2 = @dr.find {|district| district.name == symbol[:against]}
    year_set_2 = dist_name_2.enrollment.kindergarten_participation_by_year
    trends = year_set_1.merge(year_set_2) do |key, oldval, newval|
      result = oldval / newval
      (result.to_f * 1000).floor/1000.0
    end
  end

  def average_district_graduation_rate(district_name)
    district = @dr.find {|district| district.name == district_name}
    total =
      district.enrollment.graduation_rate_by_year
                         .reduce(0) do |sum, percent|
                           sum + percent[1]
                         end
    avg = total / district.enrollment.graduation_rate_by_year.length
    (avg.to_f*1000).floor/1000.0
  end

  def graduation_rate_variation(name, symbol)
    dist_1 = average_district_graduation_rate(name)
    dist_2 = average_district_graduation_rate(symbol[:against])
    rate_variation = dist_1 / dist_2
    (rate_variation.to_f * 1000).floor/1000.0
  end

  def kindergarten_participation_against_high_school_graduation(district)
    num = kindergarten_participation_rate_variation(district,
                                                    :against => 'COLORADO')/
          graduation_rate_variation(district, :against => 'COLORADO')
    num.round(3)
  end

  def correlation?(variation)
    if variation > 0.6 && variation < 1.5
      return true
    else
      return false
    end
  end

  def district_correlations
    @correlations = {}
    @dr.each do |district|
      if district.name != 'COLORADO'
        variation =
        kindergarten_participation_against_high_school_graduation(district.name)
        @correlations[district.name] = variation
      end
    end
  end

  def district_correlation?(district)
    value = @correlations[district]
    correlation?(value)
  end

  def state_correlation?
    values = @correlations.values
    correlation_values = values.map {|value| correlation?(value) == true}
    if correlation_values.length / @correlations.values.length > 0.7
      return true
    else
      return false
    end
  end

  def across_correlation?(districts)
    list = districts.map {|district| district_correlation?(district) == true}
    true_list = list.delete(false)
    correlation = true_list.length / districts.length
    correlation?(correlation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(symbol)
    if symbol[:for] == 'STATEWIDE'
      state_correlation?
    elsif symbol[:for]
      district_correlation?(symbol[:for])
    end
    # else symbol[:across]


  end


end
