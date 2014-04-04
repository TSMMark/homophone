module WordSetsHelper
  def describe_query(string, type="include")
    type != "begin" ? "include \"#{string}\"" : "begin with \"#{string}\""
  end

  def homophones_that_begin_with_path(letter)
    "/word_sets?type=begin&q=#{letter}"
  end

  def homophones_that_include_path(letter)
    "/word_sets?type=include&q=#{letter}"
  end

end
