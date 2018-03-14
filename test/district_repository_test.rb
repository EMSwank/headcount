require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_exists
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_load_data
    dr = DistrictRepository.new
    file = './test/fixtures/kinder_full_day.csv'

    expected = dr.load_data(file)

    assert_instance_of Array, expected
  end

  def test_it_finds_by_name
    dr = DistrictRepository.new
    # binding.pry
    dr.load_data({ :enrollment => {
            :kindergarten => "./data/Kindergartners in full-day program.csv"}
          })
    # district = dr.find_by_name("ACADEMY 20")

    assert_equal "A 20", district
  end
end
