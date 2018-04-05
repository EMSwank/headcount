require 'CSV'
require_relative 'general_calculations'

class EconomicProfileRepository
  include GeneralCalculations

  def load_data(data)
    @median_household_income = data[:economic_profile][:median_household_income]
    @children_in_poverty = data[:economic_profile][:children_in_poverty]
    @free_or_reduced_price_lunch = data[:economic_profile]
                                       [:free_or_reduced_price_lunch]
    @title_i = data[:economic_profile][:title_i]
  end

  def get_profiles
    
  end
end
