class MakeTaxonsLonger < ActiveRecord::Migration
  def change
    change_column :products, :taxon_ru, :text
    change_column :products, :taxon_en, :text
  end
end
