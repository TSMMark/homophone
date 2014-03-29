module SearchConcern

  def ilike_string(string, type="include")
    type == "begin" ? "#{string}%" : "%#{string}%"
  end

end
