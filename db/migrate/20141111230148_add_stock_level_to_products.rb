class AddStockLevelToProducts < ActiveRecord::Migration
  def change
    add_column :products , :stock_level , :string
    add_column :products , :category_id , :integer

  end
end
