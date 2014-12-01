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

ActiveRecord::Schema.define(version: 20141201140653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", primary_key: "authorid", force: true do |t|
    t.string   "authorru",      limit: 45
    t.string   "authoren",      limit: 45
    t.boolean  "international"
    t.decimal  "confirmed",                precision: 3, scale: 0
    t.string   "confirmedby",   limit: 45
    t.datetime "dateconfirmed"
    t.integer  "duplicateof",   limit: 8
    t.integer  "bookinfo",                                         default: 0, null: false
    t.integer  "bookinfo_en",                                      default: 0, null: false
    t.integer  "bookinfo_ru",                                      default: 0, null: false
  end

  add_index "authors", ["authorru"], name: "authors_idx_authorru", using: :btree
  add_index "authors", ["authorru"], name: "authors_search", using: :btree
  add_index "authors", ["confirmed"], name: "authors_conf", using: :btree

  create_table "bookisbns", primary_key: "bookisbnid", force: true do |t|
    t.integer "bookid",    limit: 8
    t.string  "isbn",      limit: 150
    t.string  "source",    limit: 45
    t.boolean "confirmed",             default: true, null: false
  end

  add_index "bookisbns", ["bookid", "isbn"], name: "bookisbns_idx_bookisbn", using: :btree
  add_index "bookisbns", ["bookid"], name: "bookisbns_idx_book", using: :btree
  add_index "bookisbns", ["isbn"], name: "bookisbns_idx_isbn", using: :btree

  create_table "booklock", primary_key: "idbooklock", force: true do |t|
    t.integer "bookid", limit: 8, null: false
    t.integer "userid",           null: false
  end

  create_table "bookpublishers", primary_key: "idvalidation_books_publishers", force: true do |t|
    t.integer "bookid",      limit: 8, null: false
    t.integer "publisherid", limit: 8, null: false
  end

  add_index "bookpublishers", ["bookid"], name: "bookpublishers_idxbookid", using: :btree

  create_table "booktranslations", primary_key: "booktranslationid", force: true do |t|
    t.integer  "bookid",            limit: 8,  null: false
    t.text     "titleen"
    t.text     "descriptionen"
    t.datetime "dateconfirmed"
    t.datetime "datelasteffective"
    t.string   "confirmedby",       limit: 45
    t.integer  "synccode"
    t.integer  "weight"
  end

  add_index "booktranslations", ["bookid"], name: "booktranslations_idbookid", using: :btree
  add_index "booktranslations", ["bookid"], name: "booktranslations_idxbookid", using: :btree
  add_index "booktranslations", ["booktranslationid"], name: "booktranslations_booktranslationid_unique", unique: true, using: :btree
  add_index "booktranslations", ["datelasteffective"], name: "booktranslations_idx1", using: :btree
  add_index "booktranslations", ["datelasteffective"], name: "booktranslations_idxlasteffective", using: :btree

  create_table "categories", force: true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "self_id"
    t.string  "name_en"
  end

  create_table "o_products", force: true do |t|
    t.text    "titleru"
    t.decimal "price",                         precision: 10, scale: 0
    t.string  "currency"
    t.string  "author"
    t.string  "publisher"
    t.integer "year"
    t.string  "isbn"
    t.string  "image"
    t.string  "language"
    t.string  "pages"
    t.text    "descriptionrU"
    t.string  "barcode"
    t.integer "printrun"
    t.string  "subject_code"
    t.string  "measure_type_code"
    t.string  "weight"
    t.string  "width"
    t.string  "thickness"
    t.string  "binding",           limit: 45
    t.string  "cover"
    t.integer "site_id"
    t.string  "height"
    t.string  "stock_level"
    t.integer "category_id"
    t.string  "imageurl",          limit: 350
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
    t.text    "titleru"
    t.decimal "price",                         precision: 10, scale: 0
    t.string  "currency"
    t.string  "author"
    t.string  "publisher"
    t.integer "year"
    t.string  "isbn"
    t.string  "image"
    t.string  "language"
    t.string  "pages"
    t.text    "descriptionru"
    t.string  "barcode"
    t.integer "printrun"
    t.string  "subject_code"
    t.string  "measure_type_code"
    t.string  "weight"
    t.string  "width"
    t.string  "thickness"
    t.string  "binding",           limit: 45
    t.string  "cover"
    t.string  "site_id"
    t.string  "height"
    t.string  "stock_level"
    t.integer "category_id"
    t.string  "imageurl",          limit: 350
    t.string  "publicationdate"
    t.string  "releasedate"
    t.string  "authorname"
    t.decimal "vat"
    t.string  "rrp"
    t.integer "ozon_id"
    t.string  "source"
    t.string  "source_id"
    t.string  "format"
    t.string  "sessionid"
    t.integer "confirmed"
    t.integer "old_id"
    t.string  "taxon_en"
    t.string  "taxon_ru"
  end

  create_table "publisherlist", primary_key: "publisherid", force: true do |t|
    t.string "publishernameru", limit: 150
    t.string "publishernameen", limit: 150
  end

  add_index "publisherlist", ["publishernameen"], name: "publisherlist_idx1", using: :btree

  create_table "publisherlistisbn", primary_key: "publisherlistisbnid", force: true do |t|
    t.integer "publisherid",            null: false
    t.string  "isbn10",      limit: 45
    t.string  "isbn13",      limit: 45
  end

  add_index "publisherlistisbn", ["isbn10"], name: "publisherlistisbn_idx_isbn", unique: true, using: :btree
  add_index "publisherlistisbn", ["publisherid"], name: "publisherlistisbn_publisherid_idx", using: :btree
  add_index "publisherlistisbn", ["publisherlistisbnid"], name: "publisherlistisbnid_unique", unique: true, using: :btree

  create_table "suggestedtitleslist", primary_key: "idsuggestedtitles", force: true do |t|
    t.string  "listname", limit: 95
    t.integer "publish",             default: 0
  end

  create_table "suggestedtitleslistitems", primary_key: "idsuggestedtitleslistitems", force: true do |t|
    t.integer "idsuggestedtitleslistperiod", limit: 8
    t.string  "barcode",                     limit: 45
    t.integer "bookid",                      limit: 8
  end

  add_index "suggestedtitleslistitems", ["bookid"], name: "suggestedtitleslistitems_idx_bookid", using: :btree

  create_table "suggestedtitleslistperiod", primary_key: "idnewlist", force: true do |t|
    t.integer "idsuggestedtitles"
    t.integer "month"
    t.integer "year"
    t.integer "tmpid"
    t.integer "publish"
  end

  create_table "users", primary_key: "userid", force: true do |t|
    t.string  "username",     limit: 50,                                     null: false
    t.string  "password",     limit: 50,                                     null: false
    t.decimal "addpublisher",            precision: 3, scale: 0, default: 0, null: false
    t.decimal "runstats",                precision: 3, scale: 0, default: 0, null: false
    t.decimal "agency",                  precision: 3, scale: 0, default: 0, null: false
    t.decimal "active",                  precision: 3, scale: 0, default: 0, null: false
  end

  add_index "users", ["username"], name: "users_username", unique: true, using: :btree

  create_table "usersessions", primary_key: "userhistoryid", force: true do |t|
    t.integer  "userid"
    t.string   "username",     limit: 50
    t.datetime "logindate"
    t.datetime "logoffdate"
    t.datetime "lastactivity"
    t.string   "sessionid",    limit: 32
  end

  create_table "userviews", primary_key: "userviewsid", force: true do |t|
    t.integer  "userid",                            null: false
    t.string   "sessionid",  limit: 45,             null: false
    t.integer  "bookid",     limit: 8,              null: false
    t.datetime "dateviewed"
    t.integer  "validated",             default: 0
  end

end
