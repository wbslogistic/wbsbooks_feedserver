class AddingIndexToOzonBookToCategoryRelation < ActiveRecord::Migration
  def change
    add_index :ozon_prod_caty_rel, :category_id
    add_index :ozon_prod_caty_rel, :book_id
  end
end
