module SearchConcern

  def ilike_string(string, type = "include")
    Utils::Queries.ilike_string(string, type)
  end

end
