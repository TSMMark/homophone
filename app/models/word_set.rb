class WordSet < ActiveRecord::Base
  extend SearchConcern

  has_many :words
  has_many :slugs

  attr :current_query

  module ClassMethods
    attr_accessor :current_query
    attr_accessor :current_query_type

    def current_query= value
      @current_query = value.is_a?(String) ? value.downcase : value
    end

  end
  extend ClassMethods

  def words= words
    words.map! { |w| Word.self_or_new(w) }
    super words
  end

  def append_word word
    words << Word.self_or_new(word).tap { |w| w.word_set_id = id }
  end

  def words_matches_preceding(string = nil)
    string.downcase! if string.is_a? String

    current_query = string

    return word_order_lists[string] if word_order_lists[string]

    all_words = words.order("lower(text) DESC").all

    return word_order_lists[string] = all_words.sort if string.nil?

    begins    = []
    includes  = []
    other     = []

    all_words.each do |w|
      case w.current_query_index_of_text
      when nil
        other
      when 0
        begins
      else
        includes
      end << w
    end

    return word_order_lists[string] = begins.sort + includes.sort + other.sort
  end

  def words_ordered_by_query(query = nil)
    words_matches_preceding(query)
  end

  def words_ordered_by_current_query
    words_ordered_by_query(current_query)
  end

  def current_query
    @current_query || self.class.current_query
  end


  def print_words
    words.map { |w|"\"#{w.display}\"" }.join ", "
  end


  def <=> another
    words_ordered_by_current_query.first.text.downcase <=> another.words_ordered_by_current_query.first.text.downcase
  end

  def to_slug
    slug.to_s
  end

  def slug
    @slug ||= slugs.order(:created_at).last
  end


  protected


  def word_order_lists
    @word_order_lists ||= {}
  end

  after_commit :cleanup_unlinked_words
  def cleanup_unlinked_words
    Word.destroy_unlinked
  end

end
