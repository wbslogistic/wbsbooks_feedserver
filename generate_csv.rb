require './add_things'
require 'csv'


def create_csv_template
  columns= "name,description,slug,meta_description,meta_keywords,shipping_category_id,sku,price,Taxons,Available On,p_count,Images,product_properties,translation".split(",")
     Helper.delete_if_exists @@config["spree_csv_path"]
    CSV.open(@@config["spree_csv_path"] , "w",{:col_sep => ","}) do |csv|
      csv << columns
    end
end



class String
  def r_quote()
  replace (self.gsub("&quot;"," "))
  end
end


#SKU	Name	Description	Available On	Price	CostPrice	product_properties	Taxons	OptionTypes	Variants	count_on_hand

def  write_to_csv product_obj , i
  return if !product_obj

     stock_level = "2014-09-09" if  product_obj.stock_level and product_obj.stock_level > 0


  image_url = File.exist?(product_obj.imageurl) ?  "public/" + product_obj.imageurl[2..-1] : nil

  #------------------- PROPERTIES ------------------------------------------

  product_properties = ""
  product_properties += "Publisher:" + product_obj.publisher.to_s.gsub("&quot;","''") + ";" if product_obj.publisher # this property is not necessary
  product_properties += "Publication Year:" + product_obj.year.to_s.gsub("&quot;","''")+ ";"  if product_obj.year
  product_properties += "ISBN:" + product_obj.isbn.to_s + ";" if product_obj.isbn

  product_properties += "Height:" + product_obj.height.to_s  + ";" if product_obj.height
  product_properties += "Width:" + product_obj.width.to_s + ";" if product_obj.width
  product_properties += "Weight:" + product_obj.weight.to_s + ";" if product_obj.weight

  product_properties += "Thickness:" + product_obj.thickness.to_s + ";" if product_obj.thickness
  product_properties += "Format:" + product_obj.binding.to_s  + ";" if product_obj.binding
  product_properties += "In stock:" + product_obj.stock_level.to_s  + ";" if product_obj.stock_level
  product_properties += "Page count:" + product_obj.pages.to_s  + ";" if product_obj.pages
  product_properties= product_properties.gsub(";","|")


#-------------------TAXONS------------------------------------------

  taxons ="Categories>Business books|"
  taxons += "Authors>" + product_obj.author.r_quote +  "|" if product_obj.author
  taxons += "Publishers>" + product_obj.publisher.r_quote if product_obj.publisher
  taxons.strip

#-------------------TRANSLATION------------------------------------------

  translation = Booktranslation.find_by(:bookid =>  product_obj.id)

  translation_title = (translation) ? translation.titleen  : ""
  translation_description = (translation) ? translation.descriptionen  : ""

  translation_text = translation_title + ":"  + translation_description
  translation_text = nil if translation_text==":"

  values =  [product_obj.titleru.gsub("\n"," </br> "), product_obj.descriptionru.gsub("\n"," </br> "),"slug_"+
             (182+i).to_s,"meta description","meta keyword","default",product_obj.isbn, product_obj.price,taxons,"2014-01-01",33,image_url,product_properties,translation_text]

             #stock_level,p.price,p.price,"","general","","", "default"]

  #values = values +  [p.variants.to_s,p.v_SKU.to_s,  p.v_price.to_s,p.v_length.to_s,p.v_weight.to_s,p.v_height.to_s,p.v_depth.to_s,p.v_width.to_s,p.v_diameter.to_s,p.v_pack_height.to_s,p.v_pack_width.to_s,p.pack_height.to_s,p.pack_weight.to_s,p.v_images.to_s.to_s ] if  p.product_variants && p.product_variants.count > 0
  CSV.open(@@config["spree_csv_path"], "a+",{:col_sep => ","}) do |csv|
    csv <<  values
  end
end

ActiveRecord::Base.logger = Logger.new(STDOUT)


create_csv_template


products =  Product.where(:confirmed => 1)



products.each_with_index do |p,i|


   write_to_csv p,i
end










#working sql !!!
# Copy (SELECT isbn as "SKU" ,
#                      "titleRU" as "Name",
#                                   "descriptionRU" as Description,
#                                                      'True' as "Available On",
#                                                                price as "Price",
#                                                                         'NoATaxonYet' as Taxons ,
#                                                                                          currency,
#                                                                                          "Author",
#                                                                                          "Publisher",
#                                                                                          "Year",
#                                                                                          Weight
# FROM products as t1
#
# limit 10)
# To '/tmp/result.csv' With  csv HEADER;
#




# sql = %q[SELECT isbn as "SKU" ,
#      'titleRU' as "Name",
#      'descriptionRU' as Description,
#      'True' as "Available On",
#      price as "Price",
#      'NoATaxonYet' as Taxons ,
#      currency,
#       "Author",
#      "Publisher",
#      "Year",
#      Weight
#   FROM products as t1
#
#   limit 10;
#
# "] # Single quoting
#

#
# columns= ["SKU", "Recalculate", "Name", "Designer", "Type_of_product", "Description", "Available On",
#  "shipping_category", "Price", "CostPrice", "product_properties",
#  "Length", "Weight", "Height", "Depth", "Width", "Diameter",
#  "Pack_length", "Pack_width", "Pack_height", "Pack_weight",
#  "Taxons", "Images", "Variants", "Variant_sku", "Variant_price",
#  "Variant_length", "Variant_weight", "Variant_height", "Variant_depth",
#  "Variant_width", "Variant_diameter", "Variant_pack_length", "Variant_pack_width",
#  "variant_pack_height", "Variant_pack_weight", "Variant_images" ]


