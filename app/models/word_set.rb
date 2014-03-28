class WordSet < ActiveRecord::Base
  has_and_belongs_to_many :words

  def words= words
    words.map! { |w| w.is_a?(Word) ? w : Word.find_or_create_by(text: w) }
    super words
  end
end
