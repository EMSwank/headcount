require 'CSV'
require_relative 'general_calculations'
require_relative 'statewide_test'

class StatewideTestRepository
  include GeneralCalculations

  attr_reader :test_scores

  def load_data(categories)
    @third_grade_scores       = categories[:statewide_testing][:third_grade]
    @eighth_grade_scores      = categories[:statewide_testing][:eighth_grade]
    @math_race_proficiency    = categories[:statewide_testing][:math]
    @reading_race_proficiency = categories[:statewide_testing][:reading]
    @writing_race_proficiency = categories[:statewide_testing][:writing]
    @test_scores = get_test_data(@third_grade_scores)
    uniq_districts
    add_third_grade_data
    add_eighth_grade_data
    require 'pry'; binding.pry
    add_race_data(@math_race_proficiency)
    add_race_data(@reading_race_proficiency)
    add_race_data(@writing_race_proficiency)
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
      test_index = find_indexes_for_scores(row)
      add_third_grade_subject_scores(row, test_index)
    end
    @test_scores
  end

  def add_eighth_grade_data
    data = get_data(@eighth_grade_scores)
    data.map do |row|
      parse_rows(row)
      test_index = find_indexes_for_scores(row)
      add_eighth_grade_subject_scores(row, test_index)
    end
    @test_scores
  end

    def add_race_data(data_set)
      data = get_data(data_set)
      data.map do |row|
        parse_rows_race(row)
        test_index = find_indexes_for_scores(row)
        add_math_race_data(row, test_index)
        add_reading_race_data(row, test_index)
        add_writing_race_data(row, test_index)
      end
      @test_scores
    end

  def find_indexes_for_scores(row)
    @test_scores.find_index do |test|
      test.name == row[:location].upcase
    end
  end

  def add_third_grade_subject_scores(row, test_index)
    entry = @test_scores[test_index].third_grade[row[:timeframe]]
    if entry != nil
      entry.merge!(row[:score].to_sym => row[:data])
    else
      entry = {row[:score].to_sym => row[:data]}
    end
  end

  def add_eighth_grade_subject_scores(row, test_index)
    entry = @test_scores[test_index].eighth_grade[row[:timeframe]]
    if entry != nil
      entry.merge!(row[:score].to_sym => row[:data])
    else
      entry = {row[:score].to_sym => row[:data]}
    end
  end

  def find_by_name(name)
    @test_scores.find {|score| score.name == name}
  end

  def add_math_race_data(row, test_index)
    race = convert_to_symbol(row[:race])
    entry = @test_scores[test_index].race_data[race][row[:timeframe]]
    if entry != nil
      entry.merge!(:math => row[:data])
    else
      entry = {:math => row[:data]}
    end
  end

  def add_reading_race_data(row, test_index)
    race = convert_to_symbol(row[:race])
    entry = @test_scores[test_index].race_data[race][row[:timeframe]]
    if entry != nil
      entry.merge!(:reading => row[:data])
    else
      entry = {:reading => row[:data]}
    end
  end

  def add_writing_race_data(row, test_index)
    race = convert_to_symbol(row[:race])
    entry = @test_scores[test_index].race_data[race][row[:timeframe]]
    if entry != nil
      entry.merge!(:writing => row[:data])
    else
      entry = {:writing => row[:data]}
    end
  end


  def convert_to_symbol(row)
    name = row.gsub(" " , "_")
    name.to_sym
  end
end
