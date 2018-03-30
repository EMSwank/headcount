module GeneralCalculations

  def truncate_to_three_decimals(decimal)
    (decimal.to_f*1000).floor/1000.0
  end

end
