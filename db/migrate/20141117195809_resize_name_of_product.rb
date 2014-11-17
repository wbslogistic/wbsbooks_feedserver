class ResizeNameOfProduct < ActiveRecord::Migration
  def change
    change_column :products, :titleRU,  :text
  end
end
