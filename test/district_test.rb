require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_it_exists
    district = District.new({:name => "ACADEMY 20"})

    assert_instance_of District, district
  end

  def test_it_has_attributes
    district = District.new({:name => "ACADEMY 20"})

    assert_equal "ACADEMY 20", district.name 
  end
end
