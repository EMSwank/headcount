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
    add_median_household_incomes
  end

  def get_profiles(source)
    profiles = get_data(source)
    profiles.map do |row|
      row[:name] = row[:location].upcase
      EconomicProfile.new({:name => row[:name]})
    end
  end

  def add_median_household_incomes
    data = get_data(@median_household_income)
    data.each do |row|
      parse_median_incomes(row)
      index = find_index_for_profile(row)
      profiles[index].median_household_income[row[:timeframe]] = row[:data]
    end
    profiles
  end

  def parse_median_incomes(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].split('-')
    row[:timeframe] = convert_to_integer(row[:timeframe])
    if row[:data].to_i != Integer
      row[:data] == 'N/A'
    else
      row[:data] == row[:data].to_i
    end
  end

  def uniq_profiles
    profiles.uniq! {|profile| profile.name}
  end

  def find_by_name(name)
    profiles.find {|profile| profile.name == name}
  end

  def find_index_for_profile(row)
    profiles.find_index do |profile|
      profile.name == row[:location].upcase
    end
  end

  def convert_to_integer(numbers)
    numbers.map {|year| year.to_i}
  end
end
