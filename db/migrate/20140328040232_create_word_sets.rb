class CreateWordSets < ActiveRecord::Migration
  def change
    create_table :word_sets do |t|
      t.integer :visits

      t.timestamps
    end
  end
end
