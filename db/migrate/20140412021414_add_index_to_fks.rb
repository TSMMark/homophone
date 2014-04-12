class AddIndexToFks < ActiveRecord::Migration
  def change
    add_index :word_sets_words, :word_set_id
    add_index :word_sets_words, :word_id

    add_index :definitions, :word_id    
  end
end
