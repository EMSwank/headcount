require './test/test_helper'
require './lib/headcount_analyst'

class DistrictTest < Minitest::Test

  def test_it_exists
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv'}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of HeadcountAnalyst, ha
    assert_instance_of DistrictRepository, dr
  end

  def test_it_finds_district_average
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv'}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
    actual = ha.district_average("ACADEMY 20")

    assert_equal 0.406, actual
  end
end