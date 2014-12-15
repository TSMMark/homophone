class Word < ActiveRecord::Base
  extend SearchConcern

  belongs_to :word_set

  has_many :definitions, dependent: :delete_all

  auto_strip_attributes :text, nullify: true, squish: true

  validates_presence_of :text


  module ClassMethods
    def self_or_new(word_or_string)
      word_or_string.is_a?(Word) ?
        word_or_string :
        create(text: word_or_string)
    end

    def destroy_unlinked
      find_unlinked.destroy_all
    end

    def find_unlinked
      where("words.id NOT IN(
        SELECT words.id FROM words INNER JOIN word_sets ON words.word_set_id = word_sets.id
      )")
    end
  end
  extend ClassMethods


  def display
    (display_text || text).to_s
  end

  def describe_match_type(query=nil)
    query ||= WordSet.current_query

    if self.text.downcase == query
      "exact"
    elsif current_query_index_of_text == 0
      "begin"
    elsif !current_query_index_of_text.nil?
      "include"
    else
      "none"
    end
  end

  def matches_current_query? options={}
    if options[:exact]
      self.text.downcase == WordSet.current_query
    elsif WordSet.current_query_type == "begin"
      current_query_index_of_text == 0
    else
      !current_query_index_of_text.nil?
    end
  end

  def current_query_index_of_text
    @current_query_index_of_text ||=
      self.text.downcase.index(WordSet.current_query || "")
  end

  def definition
    @definition ||= get_definitions.first
  end

  def get_definitions
    defs = definitions.all

    return defs if no_definitions?

    apply_wordnik_definitions if defs.count.zero?

    definitions
  end

  # Comparator
  def <=>(another)
    text.downcase <=> another.text.downcase
  end
  

  private


  def apply_wordnik_definitions
    wordnik_definitions.each do |definition_attributes|
      definition_attributes[:word_id] = self.id
      definitions << Definition.create!(definition_attributes)
    end

    definitions
  end

  def wordnik_definitions
    @wordnik_definitions ||= Utils::Detinitions.definitions_for(self.text)
  end


  before_validation :sanitize_params
  def sanitize_params
    self.display_text = nil if display_text.blank?
  end

  # delete all definitions in case the word was changed
  after_save :delete_definitions
  def delete_definitions
    definitions.delete_all
    true
  end


end
