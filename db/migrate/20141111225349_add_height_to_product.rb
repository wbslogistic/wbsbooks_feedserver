class AddHeightToProduct < ActiveRecord::Migration


def change
  add_column :products , :height , :string
end


end
