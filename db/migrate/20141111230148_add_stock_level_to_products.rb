class AddStockLevelToProducts < ActiveRecord::Migration
  def change
    add_column :products , :stock_level , :string


  end
end
