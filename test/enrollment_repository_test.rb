require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_exists
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end
  
end
