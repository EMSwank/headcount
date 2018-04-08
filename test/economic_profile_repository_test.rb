require './test/test_helper'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_it_exists
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    assert_instance_of EconomicProfileRepository, epr
  end

  def test_it_loads_data
    epr = EconomicProfileRepository.new
    actual = epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })


    assert_instance_of Array, actual
  end

  def test_uniq_profiles
    epr = EconomicProfileRepository.new
    actual = epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })

    assert_equal 181, epr.profiles.length
  end

  def test_it_finds_by_name
    epr = EconomicProfileRepository.new
      epr.load_data({
        :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
          :children_in_poverty => "./data/School-aged children in poverty.csv",
          :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
          :title_i => "./data/Title I students.csv"
        }
      })
    ep = epr.find_by_name("ACADEMY 20")

    assert_instance_of EconomicProfile, ep
  end

  def test_convert_to_integer
    epr = EconomicProfileRepository.new
      epr.load_data({
        :economic_profile => {
          :median_household_income => "./data/Median household income.csv",
          :children_in_poverty => "./data/School-aged children in poverty.csv",
          :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
          :title_i => "./data/Title I students.csv"
        }
      })
    ep = epr.convert_to_integer(["2005", "2009"])

    assert_equal [2005, 2009], ep
  end
end
