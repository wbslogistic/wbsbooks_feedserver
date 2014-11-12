class ChangeProduction < ActiveRecord::Migration
  def change
    change_column :products, :site_id, :string

  end
end
