class RemoveOzonIdToProducts < ActiveRecord::Migration
  def change
    def change
      remove_column :products , :ozon_object_id
    end
  end
end
