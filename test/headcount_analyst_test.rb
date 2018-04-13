require './test/test_helper'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def test_it_exists
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of HeadcountAnalyst, ha
    assert_instance_of DistrictRepository, dr
  end

  def test_it_finds_district_average
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
    actual = ha.average_kindergarten_participation("ACADEMY 20")

    assert_equal 0.406, actual
  end

  def test_kindergarten_participation_rate_variation
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
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
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
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
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
    actual = ha.average_district_graduation_rate('ACADEMY 20')

    assert_equal 0.898, actual
  end

  def test_graduation_rate_variation
      data = {:enrollment => {:kindergarten =>
                              './data/Kindergartners in full-day program.csv',
                              :high_school_graduation => "./data/High school graduation rates.csv"}}
      dr = DistrictRepository.new
      dr.load_data(data)
      ha = HeadcountAnalyst.new(dr)
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
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
    actual = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')

    assert_equal 0.641, actual
  end

  def test_correlation?
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)

    assert  ha.correlation?(0.945)
    assert  ha.correlation?(1.33)
    refute  ha.correlation?(1.7)
    refute  ha.correlation?(0.554)
  end

  def test_district_correlation
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)

    assert ha.district_correlation?('ACADEMY 20')
  end

  def test_district_correlations
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of Array, ha.district_correlations
  end

  def test_across_correlation?
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
    districts_1 = ['ACADEMY 20', 'COLORADO SPRINGS 11', 'GREELEY 6']
    districts_2 = ['ACADEMY 20', 'COLORADO SPRINGS 11', 'SHERIDAN 2']

    assert ha.across_correlation?(districts_1)
    refute ha.across_correlation?(districts_2)
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    data = {:enrollment => {:kindergarten =>
                            './data/Kindergartners in full-day program.csv',
                            :high_school_graduation => "./data/High school graduation rates.csv"}}
    dr = DistrictRepository.new
    dr.load_data(data)
    ha = HeadcountAnalyst.new(dr)
    districts = ['ACADEMY 20', 'COLORADO SPRINGS 11', 'GREELEY 6']


    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_top_statewide_test_year_over_year_growth
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv",
                   },
                   :statewide_testing => {
                     :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                     :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                     :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                     :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                   }
                 })
    dr
    ha = HeadcountAnalyst.new(dr)
    district = dr.find_by_name('ACADEMY 20')
    statewide_test = district.statewide_test

    assert statewide_test.is_a?(StatewideTest)
    assert_raises InsufficientInformationError do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
    assert_raises UnknownDataError do
      ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
    end
    # assert_equal "WILEY RE-13 JT", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math).first
    # assert_equal "COTOPAXI RE-3", ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading).first
    assert_equal "BETHUNE R-5", ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing).first
    assert_equal ["jkl;sad", "sdfjkl", "fsdjakfl"], ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
  end
end
