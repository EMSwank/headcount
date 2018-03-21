require_relative 'district_repository'

class HeadcountAnalyst

  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end

  def district_average(district_name)
    district = @dr.find_by_name(district_name)
    total =
      district.enrollment.kindergarten_participation_by_year
                         .reduce(0) do |sum, pct|
                           sum + pct[1]
                         end
                         # binding.pry
    avg = total / district.enrollment.kindergarten_participation_by_year.length
    (average.to_f*1000).floor/1000.0
  end
end
