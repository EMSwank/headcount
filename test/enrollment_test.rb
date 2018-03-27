require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_it_exists
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_instance_of Enrollment, e
  end

  def test_it_has_attributes
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal "ACADEMY 20", e.name
    assert_instance_of Hash, e.kindergarten_participation
  end

  def test_kindergarten_participation_by_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    expected = {2010 => 0.391, 2011 => 0.353, 2012 => 0.267}
    actual = e.kindergarten_participation_by_year

    assert_equal expected, actual
  end

  def test_it_truncates_decimals_to_three_points
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    actual = e.truncate_to_three_decimals(0.35356)
    expected = 0.353

    assert_equal expected, actual
  end

  def test_kindergarten_participation_in_year
    e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    expected = 0.391
    actual = e.kindergarten_participation_in_year(2010)

    assert_equal expected, actual
  end

  def test_graduation_rate_by_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")

    expected = { 2010 => 0.895,
                 2011 => 0.895,
                 2012 => 0.889,
                 2013 => 0.913,
                 2014 => 0.898,
                 }
    actual = enrollment.graduation_rate_by_year

    assert_equal expected, actual
  end
end
