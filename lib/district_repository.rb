require 'CSV'

class DistrictRepository

  def load_data(file)
    data = CSV.open(file, headers: true, header_converters: :symbol)
    binding.pry
  end

  def find_by_name(district)

  end
end
