require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

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

    assert_instance_of StatewideTestRepository, str
  end

  def test_it_loads_data
    str = StatewideTestRepository.new
    data =        ({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })

    assert_instance_of Array, str.load_data(data)
  end

  def test_it_can_find_by_name
    str = StatewideTestRepository.new
    str.load_data({:statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    name = str.find_by_name("ACADEMY 20")

    assert_instance_of StatewideTest, name
    assert_equal 'ACADEMY 20', name.name
    end
end
