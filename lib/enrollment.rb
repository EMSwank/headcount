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
      converted_value = value.to_s.split(".")[1][0..2]
      new_value = '0.' + converted_value
      new_hash[year] = new_value.to_f
      #  binding.pry
    end
    new_hash
  end

end
