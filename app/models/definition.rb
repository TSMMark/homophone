class Definition < ActiveRecord::Base
  belongs_to :word

  module ClassMethods

    def build_from_wordnik(wordnik_row, options={})
      wordnik_row.symbolize_keys!
      attributes = {
        text:               wordnik_row[:text],
        part_of_speech:     wordnik_row[:partOfSpeech],
        source_dictionary:  wordnik_row[:sourceDictionary],
        attribution_text:   wordnik_row[:attributionText],
        attribution_url:    wordnik_row[:attributionUrl]
      }
      self.new(attributes.merge(options))
    end

  end
  extend ClassMethods



end
