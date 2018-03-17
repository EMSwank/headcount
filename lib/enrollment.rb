class Enrollment

  attr_reader :name,
              :kindergarten_participation,
              :year

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    truncated = {}
    @kindergarten_participation.each_pair do |year, value|
      truncated[year] = truncate_to_three_decimals(value)
    end
    return truncated
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

end
