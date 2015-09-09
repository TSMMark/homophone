module WordSetsHelper

  def homophones_to_title(word_set)
    word_set.words_ordered_by_current_query.map(&:display).join(", ")
  end

  def plain_icon(name)
    raw "<span class=\"fa fa-#{name}\"></span>"
  end

  def browse_btn
    link_to raw("Browse homophones #{plain_icon("book")}"), browse_path, class: "btn btn-primary btn-lg btn-xs-full"
  end

  def random_btn
    link_to raw("Random homophones #{plain_icon("random")}"), random_homophone_path, class: "btn btn-info btn-lg btn-xs-full"
  end

  def define_btn
    link_to raw("What is a homophone #{plain_icon("question")}"), "#what", class: "btn btn-warning btn-lg btn-xs-full"
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
