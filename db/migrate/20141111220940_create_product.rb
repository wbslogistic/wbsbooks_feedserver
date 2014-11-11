class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |product|
      product.string :name
      product.decimal :price
      product.string :currency
      product.string :author
      product.string :editor
      product.integer :year
      product.string :isbn
      product.string :image
      product.string :language
      product.string :page_count
      product.text :description
      product.string :barcode
      product.integer :print_run
      product.string :subject_code
      product.string :measure_type_code
      product.string :weight
      product.string :width
      product.string :thickness
      product.string :format
      product.string :cover
      product.integer :site_id


      # attr_accessor :id, :book_id, :price, :currency, :category_id, :author, :name, :editor, :year,
      #               :isbn, :image, :language,:page_count,:description,:barcode,:print_run,:subject_code,:measure_type_code,
      #               :weight, :stock_level, :height,:width ,:thickness ,:format , :cover, :site_id


      #category_id
    end
  end
end
