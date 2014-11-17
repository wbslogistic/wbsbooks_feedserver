class RenameOProduct < ActiveRecord::Migration
  def change
    rename_column :o_products, :description, :descriptionRU
    rename_column :o_products, :name, :titleRU
    rename_column :o_products, :year, :Year
    rename_column :o_products, :page_count, :Pages
    rename_column :o_products, :editor, :Publisher
    rename_column :o_products, :format, :Binding
    rename_column :o_products, :author, :Author
    rename_column :o_products, :print_run, :PrintRun
    rename_column :o_products, :image_path, :ImageURL
  end
end
