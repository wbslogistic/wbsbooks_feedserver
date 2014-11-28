
require './add_things'

require 'csv'

#require 'unicode'






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




sql = %q[SELECT isbn as "SKU" ,
     'titleRU' as "Name",
     'descriptionRU' as Description,
     'True' as "Available On",
     price as "Price",
     'NoATaxonYet' as Taxons ,
     currency,
      "Author",
     "Publisher",
     "Year",
     Weight
  FROM products as t1

  limit 10;

"] # Single quoting


#
# columns= ["SKU", "Recalculate", "Name", "Designer", "Type_of_product", "Description", "Available On",
#  "shipping_category", "Price", "CostPrice", "product_properties",
#  "Length", "Weight", "Height", "Depth", "Width", "Diameter",
#  "Pack_length", "Pack_width", "Pack_height", "Pack_weight",
#  "Taxons", "Images", "Variants", "Variant_sku", "Variant_price",
#  "Variant_length", "Variant_weight", "Variant_height", "Variant_depth",
#  "Variant_width", "Variant_diameter", "Variant_pack_length", "Variant_pack_width",
#  "variant_pack_height", "Variant_pack_weight", "Variant_images" ]






def create_csv_template

  columns= "name,description,slug,meta_description,meta_keywords,tax_category_id,shipping_category_id,sku,price".split(",")
 # columns = ["SKU","Recalculate", "Name","Description","Available On","price","CostPrice","product_properties","Taxons","OptionTypes","Variants","shipping_category"]

     Helper.delete_if_exists @@config["spree_csv_path"]

    CSV.open(@@config["spree_csv_path"] , "w",{:col_sep => ","}) do |csv|
      csv << columns
    end

end



#SKU	Name	Description	Available On	Price	CostPrice	product_properties	Taxons	OptionTypes	Variants	count_on_hand

def  write_to_csv p , i
  return if !p

     stock_level = "2014-09-09" if  p.stock_level and p.stock_level > 0
  #columns= "id,name,
  # description,
  # available_on,deleted_at,slug,meta_description,meta_keywords,tax_category_id,shipping_category_id,created_at,updated_a".split(",")
  #values =  ["SKU_" + i.to_s ,'true', p.titleru.to_s.gsub("\n",""), p.descriptionru.to_s.gsub("\n",""),stock_level,p.price,p.price,"","general","","", "default"]

  values =  [p.titleru.gsub("\n"," </br> "), p.descriptionru.gsub("\n"," </br> "),
             (142+i),"meta description","meta keyword",1,"default","sku_" + i.to_s, p.price]

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









