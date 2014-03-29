module WordSetsHelper
  def describe_query(string, type="include")
    type != "begin" ? "include \"#{string}\"" : "begin with \"#{string}\""
  end
end
