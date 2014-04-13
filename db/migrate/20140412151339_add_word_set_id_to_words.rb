class AddWordSetIdToWords < ActiveRecord::Migration
  def change
    add_column :words, :word_set_id, :integer
    add_index :words, :word_set_id
  end
end
