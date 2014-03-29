class WordSet < ActiveRecord::Base
  extend SearchConcern

  has_and_belongs_to_many :words

  module ClassMethods
    def search_for(string, type="include")
      joins(:words).includes(:words).where("words.text ILIKE ?", ilike_string(string, type))
    end
  end
  extend ClassMethods

  def words= words
    words.map! { |w| w.is_a?(Word) ? w : Word.find_or_create_by(text: w) }
    super words
  end

end
