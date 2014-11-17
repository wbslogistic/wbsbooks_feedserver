class ResizeImageUrlColumn < ActiveRecord::Migration
  def change
    change_column :products, :ImageURL,  :string , :limit => 350
  end
end
