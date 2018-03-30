require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_it_exists
    str = StatewideTestRepository.new
    # str.load_data({
    #     :statewide_testing => {
    #       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    #       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    #       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    #       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    #       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    #   }
    # })
    
    assert_instance_of StatewideTestRepository, str
  end
end
