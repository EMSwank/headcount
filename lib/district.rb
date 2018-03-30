require 'CSV'
require_relative 'enrollment'

class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(data)
    @name = data[:name]
    @enrollment = nil
  end

end
