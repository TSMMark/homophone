class Word < ActiveRecord::Base
  extend SearchConcern

  has_and_belongs_to_many :word_sets

  auto_strip_attributes :text, nullify: true, squish: true

  # validate :text, presence: true
  validates_presence_of :text


  module ClassMethods
    def search_for(string, type="include")
      where("text ILIKE ?", ilike_string(string, type))
    end
  end
  extend ClassMethods

end
