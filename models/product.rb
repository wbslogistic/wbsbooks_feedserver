
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






  def self.write_product_list list,reader = nil, site_id =nil , delete=true,write_images=true


    #deleting the existing ones
     Product.where(isbn: list.map{|p| p.isbn }.compact ,site_id: site_id.to_s ).delete_all if delete

    begin
      #transaction
      Product.transaction do
        list.each do |pr|
          pr.save(:validate => false)
        end
      end

      ImageDownloader.get_images(list) if write_images
      list.clear

    rescue Exception => ex
      Helper.log_and " Exception on saving product : " + ex.message + " trace = " + ex.backtrace.to_s
      list.each do |pr2|
        begin
          pr2.save(:validate => false)
        rescue Exception => ex2
          Helper.log_and " Exception on saving product: " + ex2.message + " trace = " + ex2.backtrace.to_s
          reader.read if reader
        end
      end
    end

     ImageDownloader.get_images(list) if list.count()>0 and write_images
    list.clear
    end



  #azbuka -1
  #exmo   -2
  #piter  -3
  #szko  - 4

end


