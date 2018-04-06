require_relative 'economic_profile'
require_relative 'general_calculations'

class EconomicProfileRepository
  include GeneralCalculations

  attr_reader :profiles

  def load_data(data)
    @median_household_income = data[:economic_profile][:median_household_income]
    @children_in_poverty = data[:economic_profile][:children_in_poverty]
    @free_or_reduced_lunch = data[:economic_profile][:free_or_reduced_price_lunch]
    @title_i = data[:economic_profile][:title_i]
    @profiles = get_profiles(@title_i)
    uniq_profiles
    get_medium_household_incomes
    get_children_in_poverty
    get_free_or_reduced_lunch
  end

  def get_profiles(source)
    data = get_data(source)
    data.map do |row|
      row[:name] = row[:location].upcase
      EconomicProfile.new({:name => row[:name]})
    end
  end

  def uniq_profiles
    profiles.uniq! {|profile| profile.name}
  end

  def get_medium_household_incomes
    data = get_data(@median_household_income)
    data.each do |row|
      parse_median_incomes(row)
      index = find_index_for_profiles(row)
      profiles[index].median_household_income[row[:timeframe]] = row[:data]
    end
    profiles
  end

  def parse_median_incomes(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].split('-')
    row[:timeframe] = convert_to_integer(row[:timeframe])
    if row[:data].to_i.is_a? Integer
      row[:data] = row[:data].to_i
    else
      row[:data] = 'N/A'
    end
  end

  def get_children_in_poverty
    data = get_data(@children_in_poverty)
    data.each do |row|
      parse_poverty_info(row)
      index = find_index_for_profiles(row)
      profiles[index].children_in_poverty[row[:timeframe]] = row[:data]
    end
    profiles
  end

  def parse_poverty_info(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    unless row[:dataformat] == 'Number'
      row[:data] = row[:data].to_f
    end
  end

  def get_free_or_reduced_lunch
    data = get_data(@free_or_reduced_lunch)
    data.each do |row|
      parse_free_or_reduced_lunch_info(row)
    end
    profiles
  end

  def parse_free_or_reduced_lunch_info(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    index = find_index_for_profiles(row)
    if row[:poverty_level] == 'Eligible for Free or Reduced Lunch'
      add_free_or_reduced_data(row, index)
    end
  end

  def add_free_or_reduced_data(row, index)
    # require 'pry'; binding.pry
    if row[:dataformat] == 'Percent'
      truncate_to_three_decimals(row[:data])
      symbol = :percentage
      parse_dataformat_info(row, symbol, index)
    elsif row[:dataformat] == 'Number'
      row[:data] = row[:data].to_i
      symbol = :total
      parse_dataformat_info(row, symbol, index)
    end
  end

  def parse_dataformat_info(row, symbol, index)
    unless profiles[index].free_or_reduced_price_lunch[row[:timeframe]].nil?
      profiles[index].free_or_reduced_price_lunch[row[:timeframe]]
                     .merge!(symbol => row[:data])
    else
      profiles[index].free_or_reduced_price_lunch[row[:timeframe]] =
      {symbol => row[:data]}
    end
  end

  def convert_to_integer(numbers)
    numbers.map do |number|
      number.to_i
    end
  end

  def find_index_for_profiles(row)
    profiles.find_index {|profile| profile.name == row[:location].upcase}
  end

  def find_by_name(name)
    profiles.find {|profile| profile.name == name}
  end

end
