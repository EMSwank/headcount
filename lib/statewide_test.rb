require 'csv'
require_relative 'data_errors'

class StatewideTest

  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :race_data

  def initialize(symbols)
    @name = symbols[:name]
    @third_grade  = load_third_grade(symbols)
    @eighth_grade = load_eight_grade(symbols)
    @race_data = load_race_data(symbols)
  end

  def load_third_grade(symbols)
    @third_grade  = symbols[:third_grade]
    if @third_grade.nil? then @third_grade = {} end
  end

  def load_eight_grade(symbols)
    @eighth_grade = symbols[:eighth_grade]
    if @eighth_grade.nil? then @eighth_grade = {} end
  end

  def load_race_data(symbols)
    @race_data = symbols[:race_data]
    if @race_data.nil?
      @race_data =  { :all_students => {},
                      :asian => {},
                      :black => {},
                      :pacific_islander => {},
                      :hispanic => {},
                      :native_american => {},
                      :two_or_more => {},
                      :white => {}
                    }
    end
  end

  def proficient_by_grade(grade)
    if grade == 3
      @third_grade
    elsif grade == 8
      @eighth_grade
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)
    races = @race_data.keys
    if races.include?(race)
      @race_data[race]
    else
      raise UnknownRaceError
    end
  end
end
