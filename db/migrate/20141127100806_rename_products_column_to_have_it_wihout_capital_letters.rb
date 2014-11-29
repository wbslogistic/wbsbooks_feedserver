class RenameProductsColumnToHaveItWihoutCapitalLetters < ActiveRecord::Migration
  def change
    rename_column :products, :Confirmed, :confirmed
  end
end
