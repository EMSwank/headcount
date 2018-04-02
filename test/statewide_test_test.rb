require './test/test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repository'
require './lib/data_errors'

class StatewideTestTest < Minitest::Test

  def test_it_exists
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    statewide_test = str.find_by_name('ACADEMY 20')

    assert_instance_of StatewideTest, statewide_test
  end

  def test_it_loads_data
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    statewide_test = str.find_by_name('ACADEMY 20')

    assert_instance_of Hash, statewide_test.third_grade
    assert_instance_of Hash, statewide_test.eighth_grade
    assert_instance_of Hash, statewide_test.race_data
  end

  def test_proficiency_by_grade
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    statewide_test = str.find_by_name('ACADEMY 20')

    result = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
               2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
               2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
               2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
               2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
               2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
               2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
             }

    assert_equal result, statewide_test.proficient_by_grade(3)
    assert_raises UnknownDataError, statewide_test.proficient_by_grade(5)
  end

  def test_proficient_by_race_or_ethnicity(race)
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    statewide_test = str.find_by_name('ACADEMY 20')

    result = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
               2012 => {math: 0.818, reading: 0.893, writing: 0.808},
               2013 => {math: 0.805, reading: 0.901, writing: 0.810},
               2014 => {math: 0.800, reading: 0.855, writing: 0.789},
             }

    assert_equal result, statewide_test.proficient_by_race_or_ethnicity(:asian)
  end
end
