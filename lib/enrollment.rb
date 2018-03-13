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
      converted_value = value.to_s.split(".")
      new_value = converted_value[1][0..1].join(".")
      new_hash[year] = new_value
    end
    new_hash
  end

end
