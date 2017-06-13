class SpreadsheetColumn
 def check_year field_name, value, required = false
    return [] if (required == false) && value.blank?
    return [field_name, "is required"] if value.blank?
    return [field_name, "is not a valid year"] unless valid_year? value
    [] 
  end

  def valid_year? value
    return false unless value.to_s.strip.to_i.to_s == value.to_s.strip
    (-5000..3000).include? value.to_i
  end
end