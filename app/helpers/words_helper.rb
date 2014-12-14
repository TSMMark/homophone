module WordsHelper

  def word_btn(word)
    link_to word.display, word.word_set,
      :class => "btn word-btn",
      :"data-word-id" => word.id,
      :"data-match-type" => word.describe_match_type,
      :"data-ajax" => word_path(word, format: :popover),
      :"data-toggle" => "popover",
      :"data-content" => "Loading..."
  end

end
