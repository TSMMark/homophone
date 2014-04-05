class RenameAtttributionTextToAttributionTextOnDefinition < ActiveRecord::Migration
  def change
    rename_column :definitions, :atttribution_text, :attribution_text
  end
end
