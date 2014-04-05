class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.integer :word_id
      t.string :text
      t.string :part_of_speech
      t.string :source_dictionary
      t.string :atttribution_text
      t.string :attribution_url

      t.timestamps
    end
  end
end
