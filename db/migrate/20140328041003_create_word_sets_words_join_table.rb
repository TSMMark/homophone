class CreateWordSetsWordsJoinTable < ActiveRecord::Migration
  def change
    create_table :word_sets_words do |t|
      t.integer :word_set_id
      t.integer :word_id
    end
  end
end
