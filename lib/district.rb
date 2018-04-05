require 'CSV'
require_relative 'enrollment'


class District
  attr_reader :name
  attr_accessor :enrollment, :statewide_test

  def initialize(data)
    @name = data[:name]
    @enrollment = nil
    @statewide_test = nil
  end

end
