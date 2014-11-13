# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141113151812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "self_id"
  end

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
    t.string  "image_path"
  end

  create_table "parsed_files", force: true do |t|
    t.integer "site_id"
    t.string  "file_name"
  end

  create_table "prod_test", force: true do |t|
    t.text "name"
    t.text "isbn"
  end

  create_table "products", force: true do |t|
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
    t.string  "site_id"
    t.string  "height"
    t.string  "stock_level"
    t.integer "category_id"
    t.string  "image_path"
  end

end
