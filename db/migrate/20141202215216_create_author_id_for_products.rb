class CreateAuthorIdForProducts < ActiveRecord::Migration
  def change
    add_column :products , :author_id , :integer
    end
end

