require './test/test_helper'
require './lib/headcount_analyst'

class DistrictTest < Minitest::Test

  def test_it_exists
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)

    assert_instance_of HeadcountAnalyst, ha
    assert_instance_of DistrictRepository, dr
  end

  def test_it_finds_district_average
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)
    actual = ha.average_kindergarten_participation("ACADEMY 20")

    assert_equal 0.406, actual
  end

  def test_kindergarten_participation_rate_variation
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)
    ex_1 = ha.kindergarten_participation_rate_variation('ACADEMY 20',
                                                        :against => 'COLORADO')
    ex_2 = ha.kindergarten_participation_rate_variation('ACADEMY 20',
                                          :against => 'GREELEY 6')
    assert_equal 0.766, ex_1
    assert_equal 1.009, ex_2
  end

  def test_kindergarten_participation_rate_variation_trend
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)
    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20',
                                                        :against => 'COLORADO')

    expected = {2004 => 1.258, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.687, 2013 => 0.693, 2014 => 0.661 }

    assert_equal expected, actual
  end

  def test_district_graduation_rate
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)
    actual = ha.average_district_graduation_rate('ACADEMY 20')

    assert_equal 0.898, actual
  end

  def test_graduation_rate_variation
      data = {:enrollment => {:kindergarten =>
                              './data/Kindergartners in full-day program.csv',
                              :high_school_graduation => "./data/High school graduation rates.csv"}}
      dr = DistrictRepository.new
      instance = dr.load_data(data)
      ha = HeadcountAnalyst.new(instance)
      ex_1 = ha.graduation_rate_variation('ACADEMY 20', :against =>'COLORADO')
      ex_2 = ha.graduation_rate_variation('ACADEMY 20',
                                            :against => 'GREELEY 6')
      assert_equal 1.195, ex_1
      assert_equal 1.206, ex_2

  end

  def test_kindergarten_participation_against_high_school_graduation
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)
    actual = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')

    assert_equal 0.641, actual
  end

  def test_correlation?
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    instance = dr.load_data(data)
    ha = HeadcountAnalyst.new(instance)

    assert  ha.correlation?(0.945)
    assert  ha.correlation?(1.33)
    refute  ha.correlation?(1.7)
    refute  ha.correlation?(0.554)
  end
end
