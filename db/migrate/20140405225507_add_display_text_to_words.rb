class AddDisplayTextToWords < ActiveRecord::Migration
  def change
    add_column :words, :display_text, :string
  end
end
