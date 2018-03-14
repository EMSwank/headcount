require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_exists
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end

  def test_it_takes_a_file
    er = EnrollmentRepository.new

    assert_instance_of CSV, er.load_data({
    :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
  end
end
