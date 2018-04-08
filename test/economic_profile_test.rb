require './test/test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test

  def test_it_exists
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_instance_of EconomicProfile, economic_profile
  end

  def test_median_household_income_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 50000, economic_profile.median_household_income_in_year(2005)
    assert_equal 55000, economic_profile.median_household_income_in_year(2009)
    assert_raises UnknownDataError do
      economic_profile.median_household_income_in_year(1997)
    end
  end

  def test_median_household_income_average
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 55000, economic_profile.median_household_income_average
  end

  def test_children_in_poverty_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.184, economic_profile.children_in_poverty_in_year(2012)
    assert_raises UnknownDataError do
      economic_profile.children_in_poverty_in_year(2002)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.023, economic_profile.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_raises UnknownDataError do
      economic_profile.free_or_reduced_price_lunch_percentage_in_year(2001)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 100, economic_profile.free_or_reduced_price_lunch_number_in_year(2014)
    assert_raises UnknownDataError do
      economic_profile.free_or_reduced_price_lunch_number_in_year(2001)
    end
  end

  def test_title_i_in_year
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    economic_profile = EconomicProfile.new(data)

    assert_equal 0.543, economic_profile.title_i_in_year(2015)
    assert_raises UnknownDataError do
      economic_profile.title_i_in_year(2003)
    end 
  end
end
