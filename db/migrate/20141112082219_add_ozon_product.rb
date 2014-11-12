class AddOzonProduct < ActiveRecord::Migration
  def change
    create_table "o_products", force: true do |t|
      t.string  "name"
      t.decimal "price",             precision: 10, scale: 0
      t.string  "currency"
      t.string  "author"
      t.string  "editor"
      t.integer "year"
      t.string  "isbn"
      t.string  "image"
      t.string  "language"
      t.string  "page_count"
      t.text    "description"
      t.string  "barcode"
      t.integer "print_run"
      t.string  "subject_code"
      t.string  "measure_type_code"
      t.string  "weight"
      t.string  "width"
      t.string  "thickness"
      t.string  "format"
      t.string  "cover"
      t.integer "site_id"
      t.string  "height"
      t.string  "stock_level"
      t.integer "category_id"
    end

  end
end
