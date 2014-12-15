class Slug < ActiveRecord::Base
  belongs_to :word_set

  def self.create_for_word_set(word_set)
    value = word_set.words.map(&:to_slug).join("-")
    create({
      :value => value,
      :word_set_id => word_set.id
    })
  end

  def to_s
    value
  end
end
