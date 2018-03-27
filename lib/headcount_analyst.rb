require_relative 'district_repository'

class HeadcountAnalyst

  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end

  def district_average(district_name)
    district = @dr.find {|district| district.name == district_name}
    total =
      district.enrollment.kindergarten_participation_by_year
                         .reduce(0) do |sum, pct|
                           sum + pct[1]
                         end
    avg = total / district.enrollment.kindergarten_participation_by_year.length
    (avg.to_f*1000).floor/1000.0
  end

  def kindergarten_participation_rate_variation(name, symbol)
    dist_1 = district_average(name)
    dist_2 = district_average(symbol[:against])
    rate_variation = dist_1 / dist_2
    (rate_variation.to_f * 1000).floor/1000.0
  end

  def kindergarten_participation_rate_variation_trend(name, symbol)
    # binding.pry
    dist_name_1 = @dr.find {|district| district.name == name}
    year_set_1 = dist_name_1.enrollment.kindergarten_participation_by_year
    dist_name_2 = @dr.find {|district| district.name == symbol[:against]}
    year_set_2 = dist_name_2.enrollment.kindergarten_participation_by_year
    trends = year_set_1.merge(year_set_2) do |key, oldval, newval|
      result = oldval / newval
      (result.to_f * 1000).floor/1000.0
    end
  end
end
