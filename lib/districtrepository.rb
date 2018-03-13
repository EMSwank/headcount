require 'csv'

class DistrictRepository

  def load_data(file_path)
    data = CSV.open(file_path, headers: true, header_converters: :symbol)
    add_elements(data)
  end

end
