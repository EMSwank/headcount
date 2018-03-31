require 'CSV'
require_relative 'general_calculations'

class StatewideTestRepository
  include GeneralCalculations

  def load_data(categories)
    @third_grade_scores       = categories[:statewide_testing][:third_grade]
    @eighth_grade_scores      = categories[:statewide_testing][:eighth_grade]
    @math_race_proficiency    = categories[:statewide_testing][:math]
    @reading_race_proficiency = categories[:statewide_testing][:reading]
    @writing_race_proficiency = categories[:statewide_testing][:writing]
    @test_scores = get_test_data(@third_grade_scores)

  end

  def get_test_data(source)
    data = get_data(source)
    data.map do |row|
      row[:name] = row[:location].upcase
      StatewideTest.new({:name => row[:name]})
  end

  def uniq_districts
    @test_scores.uniq! do |district|
      district.name
    end
  end
end
