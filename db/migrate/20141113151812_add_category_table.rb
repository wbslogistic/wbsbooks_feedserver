class AddCategoryTable < ActiveRecord::Migration
  def change
    create_table :categories do |product|
        product.string :name
        product.integer :parent_id
        product.integer :self_id
      end
  end
end
