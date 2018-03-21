require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_it_exists
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end

  def test_it_takes_a_file
    er = EnrollmentRepository.new
    actual = er.load_data({:enrollment => {
                :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    assert_instance_of Array, actual
  end

  def test_it_finds_by_name
    er = EnrollmentRepository.new
    er.load_data({ :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
    assert_instance_of Enrollment, er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", er.find_by_name('ACADEMY 20').name
  end

  def test_it_loads_enrollment
    er = EnrollmentRepository.new
    er.load_data({ :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
    district = "COLORADO SPRINGS 11"
    enrollment = er.find_by_name(district)

    assert_equal district, enrollment.name
    assert_equal 0.994, enrollment.kindergarten_participation_in_year(2007)
  end

  def test_it_includes_hs_data
    er = EnrollmentRepository.new
    er.load_data({
                       :enrollment => {
                       :kindergarten => "./data/Kindergartners in full-day program.csv",
                       :high_school_graduation => "./data/High school graduation rates.csv"
                       }
                     })
    enrollment = er.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', enrollment.name
    assert_equal 0.302,
                enrollment.kindergarten_participation_in_year(2004)
    assert_equal 0.889,
                enrollment.graduation_rate_in_year(2012)
  end
end
