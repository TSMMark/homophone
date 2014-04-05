module WordsHelper

  def word_btn(word)
    button_tag word.text.to_s, :"data-ajax" => word_path(word, format: :popover), :class => "btn btn-default word-btn", :"data-toggle" => "popover", :"data-placement" => "top", :"data-content" => "Loading...", :"data-original-title" => "", :title => ""
  end

end
