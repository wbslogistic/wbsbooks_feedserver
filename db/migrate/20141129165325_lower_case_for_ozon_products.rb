class LowerCaseForOzonProducts < ActiveRecord::Migration
  def change
    rename_column :o_products, :titleRU, :titleru
    rename_column :o_products, :Author, :author
    rename_column :o_products, :Publisher, :publisher
    rename_column :o_products, :Year, :year
    rename_column :o_products, :Pages, :pages
    rename_column :o_products, :descriptionRU, :descriptionrU
    rename_column :o_products, :PrintRun, :printrun
    rename_column :o_products, :Binding, :binding
    rename_column :o_products, :ImageURL, :imageurl
  end
end
