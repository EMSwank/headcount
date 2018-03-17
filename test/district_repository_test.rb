require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_exists
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_load_data
    dr = DistrictRepository.new
    expected = dr.load_data({ :enrollment => {
              :kindergarten => "./data/Kindergartners in full-day program.csv"}
            })

    assert_instance_of Array, expected
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
end
