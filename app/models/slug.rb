class Slug < ActiveRecord::Base
  belongs_to :word_set

  # TODO: validate uniqueness

  def self.create_for_word_set(word_set)
    value = value_for_word_set(word_set)
    create({
      :value => value,
      :word_set_id => word_set.id
    }).tap do |slug|
      word_set.slugs << slug
    end
  end

  def self.value_for_word_set(word_set)
    word_set.words.sort.map(&:to_slug).join("-")
  end

  def to_s
    value.to_s
  end
end
