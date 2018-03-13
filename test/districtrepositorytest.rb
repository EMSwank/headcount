require './test/test_helper'
require './lib/districtrepository'

class DistrictRepositoryTest < Minitest::Test

def test_it_exists
  dr = DistrictRepository.new

  assert_instance_of DistrictRepository, dr
end

end
