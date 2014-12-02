class RenameAColumnInOProducts < ActiveRecord::Migration
  def change
    rename_column :o_products, :descriptionrU, :descriptionru
  end
end
