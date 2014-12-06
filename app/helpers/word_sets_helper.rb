module WordSetsHelper

  def browse_btn
    link_to "Browse homophones", browse_path, class: "btn btn-primary btn-lg btn-xs-full"
  end

  def random_btn
    link_to "Random homophones", random_homophone_path, class: "btn btn-info btn-lg btn-xs-full"
  end

  def last_word_set
    @last_word_set ||= WordSet.order("id DESC").last
  end

  def describe_query(string, type="include")
    type != "begin" ? "include #{string}" : "begin with #{string}"
  end

  def homophones_that_begin_with_path(letter)
    "/search?type=begin&q=#{letter}"
  end

  def homophones_that_include_path(letter)
    "/search?type=include&q=#{letter}"
  end

  def random_word_set
    WordSet.sample
  end

end
