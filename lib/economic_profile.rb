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
    # require 'pry'; binding.pry
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
end
