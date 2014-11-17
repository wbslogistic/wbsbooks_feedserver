class ResizeAllInOProducts < ActiveRecord::Migration
  def change
    change_column :o_products, :titleRU,  :text
    change_column :o_products, :Binding,  :string , :limit => 45
    change_column :o_products, :ImageURL,  :string , :limit => 350
   end
end
