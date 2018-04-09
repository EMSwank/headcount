require 'CSV'
require_relative 'enrollment'


class District
  attr_reader :name
  attr_accessor :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(data)
    @name = data[:name]
    @enrollment = nil
    @statewide_test = nil
    @economic_profile = nil
  end

end
