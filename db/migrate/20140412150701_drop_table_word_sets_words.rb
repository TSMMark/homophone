class DropTableWordSetsWords < ActiveRecord::Migration
  def change
    drop_table :word_sets_words
  end
end
