class ChangeOneLetter < ActiveRecord::Migration
  def change

    rename_column :products, :descriptionrU, :descriptionru
  end
end
