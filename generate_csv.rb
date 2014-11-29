require './add_things'
require 'csv'


def create_csv_template
  columns= "name,description,slug,meta_description,meta_keywords,shipping_category_id,sku,price,Taxons,Available On,p_count,Images,product_properties,,".split(",")
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

def  write_to_csv p , i
  return if !p

     stock_level = "2014-09-09" if  p.stock_level and p.stock_level > 0


  image_url = File.exist?(p.imageurl) ?  "public/" + p.imageurl[2..-1] : nil

  product_properties = ""
  product_properties += "Publisher:" + p.publisher.to_s.gsub("&quot;","''") + ";" if p.publisher
  product_properties += "Publication Year:" + p.year.to_s.gsub("&quot;","''")+ ";"  if p.year
  product_properties += "ISBN:" + p.isbn.to_s + ";" if p.isbn

  product_properties += "Height:" + p.height.to_s  + ";" if p.height
  product_properties += "Width:" + p.width.to_s + ";" if p.width
  product_properties += "Weight:" + p.weight.to_s + ";" if p.weight

  product_properties += "Thickness:" + p.thickness.to_s + ";" if p.thickness
  product_properties += "Format:" + p.binding.to_s  + ";" if p.binding
  product_properties += "In stock:" + p.p.stock_level.to_s  + ";" if p.p.stock_level
  product_properties += "Page count:" + p.p.pages.to_s  + ";" if p.p.pages


  product_properties= product_properties.gsub(";","|")



  taxons ="Categories>Business books|"
  taxons += "Authors>" + p.author.r_quote +  "|" if p.author
  taxons += "Publishers>" + p.publisher.r_quote if p.publisher
  taxons.strip

    values =  [p.titleru.gsub("\n"," </br> "), p.descriptionru.gsub("\n"," </br> "),"slug_"+
             (182+i).to_s,"meta description","meta keyword","default",p.isbn, p.price,taxons,"2014-01-01",33,image_url,product_properties]

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


