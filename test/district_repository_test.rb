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
              :kindergarten => './test/fixtures/kinder_full_day.csv'}
            })

    assert_instance_of CSV, expected
  end

  def test_it_finds_by_name
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv"}
          })
    district = dr.find_by_name("ACADEMY 20")

    assert_instance_of District, district
  end
end
