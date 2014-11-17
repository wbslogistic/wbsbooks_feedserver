class ResizeBindingColumn < ActiveRecord::Migration
  def change
    change_column :products, :Binding,  :string , :limit => 45 #to test
  end
end
