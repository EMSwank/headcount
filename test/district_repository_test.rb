require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_exists
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_load_data
    dr = DistrictRepository.new
    data = ({
      :enrollment => {
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

    assert_instance_of Array, dr.load_data(data)
  end

  def test_it_finds_by_name
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv"}
          })
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of District, district
    assert_equal "ACADEMY 20", district.name
  end

  def test_it_finds_matching
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv"}
          })

    assert_instance_of Array, dr.find_all_matching("ACADEMY 20")
    assert_equal 2, dr.find_all_matching("brig").length
    assert_equal 6, dr.find_all_matching("ca").length
  end

  def test_it_instantiates_enrollment
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv"}
          })
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
  end

  def test_it_instantiates_statewide
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
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
    district = dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test

    assert_instance_of StatewideTest, statewide_test
  end
end
