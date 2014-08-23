module WordSetsHelper

  def last_word_set
    @last_word_set ||= WordSet.order("id DESC").last
  end

  def describe_query(string, type="include")
    type != "begin" ? "include \"#{string}\"" : "begin with \"#{string}\""
  end

  def homophones_that_begin_with_path(letter)
    "/word_sets?type=begin&q=#{letter}"
  end

  def homophones_that_include_path(letter)
    "/word_sets?type=include&q=#{letter}"
  end

  def random_word_set
    WordSet.sample
  end

end
