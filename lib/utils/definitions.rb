module Utils
  module Detinitions

    DEFINITION_DEFAULTS = {
      :use_canonical => true
    }

    DEFINITION_ATTRIBUTE_MAP = {
      :text => "text",
      :part_of_speech => "partOfSpeech",
      :source_dictionary => "sourceDictionary",
      :attribution_text => "attributionText",
      :attribution_url => "attributionUrl"
    }


    module_function


    # Get definitions for a string.
    #
    # @param word_text [String]
    # @param options [Hash] - options to send to Wordnik.word.get_definitions
    #
    # @return definitions_attributes [Array<Hash>]
    def definitions_for(word_text, options = {})
      options = DEFINITION_DEFAULTS.merge(options)
      defs = Wordnik.word.get_definitions(word_text, options)
      (defs.is_a?(Array) ? defs : []).map do |attributes|
        coerce_wordnik_attributes(attributes)
      end
    end

    def coerce_wordnik_attributes(definition_attributes)
      definition_attributes = definition_attributes.stringify_keys
      DEFINITION_ATTRIBUTE_MAP.each_with_object({}) do |(internal, wordnik), attributes|
        attributes[internal] = definition_attributes[wordnik]
      end
    end

  end
end
