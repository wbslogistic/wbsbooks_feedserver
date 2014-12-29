class AddOzonIdToProducts < ActiveRecord::Migration
  def change
    add_column :products , :ozon_object_id , :integer
  end
end
