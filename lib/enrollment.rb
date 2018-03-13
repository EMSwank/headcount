class Enrollment

  attr_reader :name,
              :kindergarten_participation

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    new_hash = {}
    @kindergarten_participation.each_pair do |year, value|
      new_hash[year] = truncate_to_three_decimals(value)
    end
    new_hash
  end

  def truncate_to_three_decimals(decimal)
    converted_value = decimal.to_s.split(".")[1][0..2]
    new_value = '0.' + converted_value
    new_value.to_f
  end
end
