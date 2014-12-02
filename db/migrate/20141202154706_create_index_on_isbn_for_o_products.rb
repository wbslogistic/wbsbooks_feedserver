class CreateIndexOnIsbnForOProducts < ActiveRecord::Migration
  def change
      add_index :o_products, :isbn
  end
end
