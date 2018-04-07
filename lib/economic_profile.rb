require_relative 'data_errors'

class EconomicProfile

  attr_reader :name,
              :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i

  def initialize(data)
    @name = data[:name]
    load_median_household_income(data)
    load_children_in_poverty(data)
    load_free_or_reduced(data)
    load_title_i(data)
    @income_averages = {}
    # get_median_household_incomes
  end

  def load_median_household_income(data)
    @median_household_income = data[:median_household_income]
    @median_household_income = {} if data[:median_household_income] == nil
  end

  def load_children_in_poverty(data)
    @children_in_poverty = data[:children_in_poverty]
    @children_in_poverty = {} if data[:children_in_poverty] == nil
  end

  def load_free_or_reduced(data)
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @free_or_reduced_price_lunch = {} if data[:free_or_reduced_price_lunch].nil?
  end

  def load_title_i(data)
    @title_i = data[:title_i]
    @title_i = {} if data[:title_i].nil?
  end

  def median_household_income_in_year(year)
    # @income_averages ||=
    years = @median_household_income.keys
    incomes = []
    years.each do |range|
      year_range = (range[0]..range[1]).to_a
      if year_range.include?(year)
        value = @median_household_income.fetch(range)
        require 'pry'; binding.pry
        @income_averages[year] = incomes.push(value)
      end
    end
    raise UnknownDataError if incomes.length == 0
    incomes.sum / incomes.length
    # @income_averages
  end

  def get_median_household_incomes
    years = @median_household_income
    incomes = []
    years.each do |key, val|
      year_range = (key[0]..key[1]).to_a
      if year_range.include?(year) && if 
        @income_averages[year] =
      end

    end
    average_median_household_incomes
  end

  def average_median_household_incomes
    @income_averages.each do |key, val|
      no_repeat_values = val.uniq.concat
      @income_averages[key] = no_repeat_values
    end
    @income_averages.each do |key, val|
      avg = val.sum / val.length
      @income_averages[key] = avg
    end
  end

  def median_household_income_average

  end
end
