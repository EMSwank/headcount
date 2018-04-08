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
    build_income_averages
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
    raise UnknownDataError if @income_averages[year] == nil
    @income_averages[year]
  end

  def build_income_averages
    incomes = @median_household_income
    incomes.each do |key, val|
      add_years_to_income_averages(key, val)
    end
    average_income_averages
  end

  def add_years_to_income_averages(key, val)
    years = (key[0]..key[1]).to_a
    years.each do |year|
      if @income_averages[year] == nil
        @income_averages[year] = [val]
      elsif @income_averages.key?(year)
        @income_averages[year] = @income_averages.fetch(year) << val
      end
    end
  end

  def average_income_averages
    @income_averages.each do |key, value|
      if value.length == 0
        new_value = []
      else
        new_value = value.sum / value.length
      end
      @income_averages[key] = new_value
    end
  end

  def median_household_income_average
    incomes = @median_household_income.values
    incomes.sum / incomes.length
  end
end
