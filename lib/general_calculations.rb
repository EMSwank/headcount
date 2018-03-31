module GeneralCalculations

  def get_data(file_path)
    CSV.open(file_path, {headers: true, header_converters: :symbol})
  end

  def truncate_to_three_decimals(decimal)
    (decimal.to_f*1000).floor/1000.0
  end

  def parse_rows(row)
    row[:name] = row[:location].upcase
    row[:timeframe] = row[:timeframe].to_i
    row[:data] = row[:data].to_f
  end


end
