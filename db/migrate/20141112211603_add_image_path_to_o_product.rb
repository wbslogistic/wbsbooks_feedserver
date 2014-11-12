class AddImagePathToOProduct < ActiveRecord::Migration
  def change
    add_column :o_products , :image_path , :string
  end
end
