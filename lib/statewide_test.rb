
class StatewideTest

  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :race_data

  def initialize(symbols)
    @name         = symbols[:name]
    @third_grade  = symbols[:third_grade]
    @eighth_grade = symbols[:eighth_grade]
    @race_data    = symbols[:race_data]
  end

  def load_third_grade
    @third_grade  = symbols[:third_grade]
    if @third_grade.nil? then @third_grade = {} end
  end

  def load_eight_grade
    @eighth_grade = symbols[:eighth_grade]
    if @eighth_grade.nil? then @eighth_grade = {} end
  end

  def load_race_data
    @race_data = symbols[:race_data]
    if @race_data.nil?
      @race_data =  { :all_students => {},
                      :asian => {},
                      :black => {},
                      :pacific_islander => {},
                      :hispanic => {},
                      :native_american => {},
                      :tow_or_more => {},
                      :white => {}
                    }
    end
  end
end
