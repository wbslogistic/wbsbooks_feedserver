class AddTaxonColumnsToProduct < ActiveRecord::Migration
  def change
    add_column :products , :taxon_en , :string
    add_column :products , :taxon_ru , :string
  end
end
