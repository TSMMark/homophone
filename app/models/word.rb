class Word < ActiveRecord::Base
  extend SearchConcern

  has_and_belongs_to_many :word_sets

  has_many :definitions, dependent: :delete_all

  auto_strip_attributes :text, nullify: true, squish: true

  # validate :text, presence: true
  validates_presence_of :text


  module ClassMethods
    def search_for(string, type="include")
      where("text ILIKE ?", ilike_string(string, type))
    end

    def self_or_new word_or_string
      word_or_string.is_a?(Word) ?
        word_or_string :
        Word.find_or_create_by(text: word_or_string)
    end
  end
  extend ClassMethods

  def definition
    @definition ||= get_definitions.first
  end

  def get_definitions
    defs = definitions.all

    return defs if no_definitions?

    apply_wordnik_definitions if defs.count.zero?

    definitions
  end

  # comparator
  def <=>(another)
    text.downcase <=> another.text.downcase
  end
  

  protected


  def apply_wordnik_definitions
    wordnik_definitions.each do |row|
      definition = Definition.build_from_wordnik(row).tap do |d|
        d.word_id = self.id
        d.save!
      end
      definitions << definition
    end
    definitions
  end

  def wordnik_definitions
    @wordnik_definitions ||= Wordnik.word.get_definitions(self.text)
  end


  private


  # delete all definitions in case the word was changed
  after_save :delete_definitions
  def delete_definitions
    definitions.delete_all
    true
  end


end
