class Word < ActiveRecord::Base
  has_and_belongs_to_many :word_sets

  auto_strip_attributes :text, nullify: true, squish: true

  # validate :text, presence: true
  validates_presence_of :text
end
