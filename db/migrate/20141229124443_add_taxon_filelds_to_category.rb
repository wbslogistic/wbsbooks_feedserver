class AddTaxonFileldsToCategory < ActiveRecord::Migration
  def change
    add_column :categories , :taxon_en , :text
    add_column :categories , :taxon_ru , :text
  end
end
