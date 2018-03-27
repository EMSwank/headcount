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

end
