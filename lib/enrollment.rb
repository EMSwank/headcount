class Enrollment

  attr_reader :name
  attr_accessor :kindergarten_participation, :high_school_graduation_rates

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation]
    @high_school_graduation_rates = data[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |year, value|
      year.merge(value.first => truncate_to_three_decimals(value.last))
    end
  end

  def truncate_to_three_decimals(decimal)
    converted_value = decimal.to_s.split(".")
    new_value = converted_value[0] + "." + converted_value[1][0..2]
    new_value.to_f
  end

  def kindergarten_participation_in_year(year)
    value = @kindergarten_participation[year]
    truncate_to_three_decimals(value)
  end

  def graduation_rate_by_year
    @high_school_graduation_rates.reduce({}) do |year, value|
      year.merge(value.first => truncate_to_three_decimals(value.last))
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end
end
