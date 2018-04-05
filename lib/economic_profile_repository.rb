require 'CSV'
require_relative 'economic_profile'
require_relative 'general_calculations'

class EconomicProfileRepository
  include GeneralCalculations

  attr_reader :profiles
  def load_data(data)
    @median_household_income = data[:economic_profile][:median_household_income]
    @children_in_poverty = data[:economic_profile][:children_in_poverty]
    @free_or_reduced_price_lunch = data[:economic_profile]
                                       [:free_or_reduced_price_lunch]
    @title_i = data[:economic_profile][:title_i]
    @profiles = get_profiles(@title_i)
    uniq_profiles
  end

  def get_profiles(source)
    profiles = get_data(source)
    profiles.map do |row|
      row[:name] = row[:location].upcase
      # require 'pry'; binding.pry
      EconomicProfile.new({:name => row[:name]})
    end
  end

  def uniq_profiles
    profiles.uniq! {|profile| profile.name}
  end

  def find_by_name(name)
    profiles.find {|profile| profile.name == name}
  end
end
