module Utils
  module Routes

    module_function

    def slug_path(word_set)
      "/h/#{word_set.to_slug}"
    end

  end
end
