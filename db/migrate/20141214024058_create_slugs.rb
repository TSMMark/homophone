class CreateSlugs < ActiveRecord::Migration
  def change
    create_table :slugs do |t|
      t.integer :word_set_id
      t.string :value

      t.timestamps

      t.index :value, :unique => true
      t.index :created_at
    end
  end
end
