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

    def test_uniq_districts
      str = StatewideTestRepository.new
      str.load_data({:statewide_testing => {
                        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                      }
                    })
      assert_equal 181, str.test_scores.count
    end

    def test_it_builds_hash_from_data
      str = StatewideTestRepository.new
      str.load_data({:statewide_testing => {
                        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                      }
                    })
      test_1 = str.test_scores[0].third_grade[2008]
      exp_1 = {:math=>0.697, :reading=>0.703, :writing=>0.501}
      test_2 = str.test_scores[0].third_grade[2012]
      exp_2 = {:reading=>0.739, :math=>0.71, :writing=>0.525}
      test_3 = str.test_scores[3].eighth_grade[2010]
      exp_3 = {:math=>0.369, :reading=>0.496, :writing=>0.326}
      test_4 = str.test_scores[2].race_data[:native_american][2013]
      exp_4 = {:math=>0.36, :reading=>0.56, :writing=>0.32}

      assert_equal exp_1, test_1
      assert_equal exp_2, test_2
      assert_equal exp_3, test_3
      assert_equal exp_4, test_4
    end
end
