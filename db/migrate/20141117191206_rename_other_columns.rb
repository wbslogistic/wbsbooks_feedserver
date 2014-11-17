class RenameOtherColumns < ActiveRecord::Migration
  def change
     rename_column :products, :page_count, :Pages
     rename_column :products, :editor, :Publisher
     rename_column :products, :format, :Binding
     rename_column :products, :author, :Author
     rename_column :products, :print_run, :PrintRun
     rename_column :products, :image_path, :ImageURL
  end
end
