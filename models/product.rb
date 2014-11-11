
require 'active_record'

class Product  < ActiveRecord::Base

  # attr_accessor :id, :book_id, :price, :currency, :category_id, :author, :name, :editor, :year,
  #               :isbn, :image, :language,:page_count,:description,:barcode,:print_run,:subject_code,:measure_type_code,
  #               :weight, :stock_level, :height,:width ,:thickness ,:format , :cover, :site_id

  #products

  def rise_price
    if self.price and self.price.to_s.length > 0
      self.price = (self.price.to_s.gsub(",",".").to_f * 1.8).round(2)
    end
  end










  #azbuka -1
  #exmo   -2
  #piter  -3
  #szko  - 4

end


