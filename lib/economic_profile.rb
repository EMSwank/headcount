class EconomicProfile

  attr_reader :name,
              :median_household_income,
              :children_in_poverty

  def initialize(data)
    @name = data[:name]
    load_median_household_income(data)
    load_children_in_poverty(data)
  end

  def load_median_household_income(data)
    @median_household_income = {} if data[:median_household_income] == nil
  end

  def load_children_in_poverty(data)
    @children_in_poverty = {} if data[:children_in_poverty] == nil
  end
end
