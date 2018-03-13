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

    assert_equal {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}, e.kindergarten_participation_by_year
  end
end
