require_relative 'general_calculations'

class Enrollment
  include GeneralCalculations

  attr_reader   :name
  attr_accessor :kindergarten_participation,
                :high_school_graduation_rates

  def initialize(data)
    @name = data[:name]
    @kindergarten_participation = data[:kindergarten_participation]
    if @kindergarten_participation.nil?
      @kindergarten_participation = Hash.new
    end
    @high_school_graduation_rates = data[:high_school_graduation]
    if @high_school_graduation_rates.nil?
      @high_school_graduation_rates = Hash.new
    end
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |year, value|
      year.merge(value.first => truncate_to_three_decimals(value.last))
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
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
