class AddParsedFiles < ActiveRecord::Migration
  def change

    create_table :parsed_files do |product|
      product.integer :site_id
      product.string :file_name
    end
  end

 end
