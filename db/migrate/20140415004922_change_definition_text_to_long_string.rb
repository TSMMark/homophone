class ChangeDefinitionTextToLongString < ActiveRecord::Migration
  def change
    change_column :definitions, :text, :text
  end
end
