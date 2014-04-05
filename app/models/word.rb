class Word < ActiveRecord::Base
  extend SearchConcern

  has_and_belongs_to_many :word_sets

  has_many :definitions

  auto_strip_attributes :text, nullify: true, squish: true

  # validate :text, presence: true
  validates_presence_of :text


  module ClassMethods
    def search_for(string, type="include")
      where("text ILIKE ?", ilike_string(string, type))
    end
  end
  extend ClassMethods

  def definition
    definitions.limit(1).first
  end

  def definitions
    super
  end

  # comparator
  def <=>(another)
    text.downcase <=> another.text.downcase
  end
end
