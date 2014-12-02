class CreateOzonProductCategoryRel < ActiveRecord::Migration
  def change
    create_table :ozon_prod_caty_rel do |t|
      t.integer :category_id
      t.integer :book_id
    end
  end
end
