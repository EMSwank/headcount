class EconomicProfile

  attr_reader :name,
              :median_household_income

  def initialize(data)
    @name = data[:name]
    load_median_household_income(data)
  end

  def load_median_household_income(data)
    if data[:median_household_income] == nil
      @median_household_income = {}
    end
  end
end
