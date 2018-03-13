require 'csv'

class DistrictRepository

  def load_data(file)
    data = CSV.open(file, headers: true, header_converters: :symbol)
  end

end
