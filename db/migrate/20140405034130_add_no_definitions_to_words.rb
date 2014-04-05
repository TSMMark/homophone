class AddNoDefinitionsToWords < ActiveRecord::Migration
  def change
    add_column :words, :no_definitions, :boolean
  end
end
