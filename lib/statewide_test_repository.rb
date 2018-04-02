require 'CSV'
require_relative 'general_calculations'
require_relative 'statewide_test'

class StatewideTestRepository
  include GeneralCalculations

  def load_data(categories)
    @third_grade_scores       = categories[:statewide_testing][:third_grade]
    @eighth_grade_scores      = categories[:statewide_testing][:eighth_grade]
    @math_race_proficiency    = categories[:statewide_testing][:math]
    @reading_race_proficiency = categories[:statewide_testing][:reading]
    @writing_race_proficiency = categories[:statewide_testing][:writing]
    @test_scores = get_test_data(@third_grade_scores)
    uniq_districts
    add_third_grade_data
  end

  def get_test_data(source)
    data = get_data(source)
    data.map do |row|
      row[:name] = row[:location].upcase
      StatewideTest.new({:name => row[:name]})
    end
  end

  def uniq_districts
    @test_scores.uniq! do |district|
      district.name
    end
  end

  def add_third_grade_data
    data = get_data(@third_grade_scores)
    data.map do |row|
      parse_rows(row)
      row[:data] = truncate_to_three_decimals(row[:data])
      test_index = find_indexes_for_scores(row)
      add_subject_scores(row, test_index)
    end
    @test_scores
  end

  def find_indexes_for_scores(row)
    @test_scores.find_index do |test|
      test.name == row[:location].upcase
    end
  end
  
  def add_subject_scores(row, test_index)
    if @test_scores[test_index].third_grade[row[:timeframe]] != nil
      @test_scores[test_index].third_grade[row[:timeframe]]
                              .merge!(row[:score].to_sym => row[:data])
    else
      @test_scores[test_index].third_grade[row[:timeframe]] =
                                          {row[:score].to_sym => row[:data]}
    end
  end

  def find_by_name(name)
    @test_scores.find {|score| score.name == name}
  end
end
