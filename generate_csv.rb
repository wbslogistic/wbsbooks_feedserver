require './add_things'
require 'csv'




class String
  def r_quote()
    replace (self.gsub("&quot;"," "))
  end
end



class CsvGenerator


def generate

 @dollar,@euro=  get_exchange_rate
 @dollar=@dollar.to_d
 @euro= @euro.to_d


  create_csv_template


  Product.where(:confirmed => 1).each_with_index do |p,i|
    write_to_csv p,i if p.isbn and p.isbn != ""
  end



end

def create_csv_template
  columns= "sku,name,description,slug,meta_description,meta_keywords,shipping_category_id,price,taxons_ru ,Taxons,Available On,p_count,Images,product_properties,translation,price_eu,price_ru".split(",")
     Helper.delete_if_exists @@config["spree_csv_path"]
    CSV.open(@@config["spree_csv_path"] , "w",{:col_sep => ","}) do |csv|
      csv << columns
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
  product_properties += "publication_year:" + product_obj.year.to_s.gsub("&quot;","''")+ ";"  if product_obj.year
  #product_properties += "ISBN:" + product_obj.isbn.to_s + ";" if product_obj.isbn

  product_properties += "HEIGHT:" + product_obj.height.to_s  + ";" if product_obj.height
  product_properties += "WIDTH:" + product_obj.width.to_s + ";" if product_obj.width
  product_properties += "WEIGHT:" + product_obj.weight.to_s + ";" if product_obj.weight

  product_properties += "DEPTH:" + product_obj.thickness.to_s + ";" if product_obj.thickness
  product_properties += "Format:" + product_obj.binding.to_s  + ";" if product_obj.binding
  product_properties += "in_stock:" + product_obj.stock_level.to_s  + ";" if product_obj.stock_level
  product_properties += "Pages:" + product_obj.pages.to_s  + ";" if product_obj.pages

  product_properties= product_properties.gsub(";","|")


#-------------------TAXONS------------------------------------------

  #taxons ="Categories>Business books|"

  taxon_en = ""
  taxon_en += product_obj.taxon_en.split("|").map do |tax|
    "Categories>" + tax + "|"
  end.join if  product_obj.taxon_en


   taxon_en = "Undefined|" if taxon_en == ""


  taxon_en += "Authors>" + product_obj.author.r_quote +  "|" if product_obj.author
  taxon_en += "Publishers>" + product_obj.publisher.r_quote if product_obj.publisher
  taxon_en.strip


  taxon_ru = ""
  taxon_ru=  product_obj.taxon_ru.split("|").map do |tax|
    "Категорий>" + tax + "|"
  end.join if  product_obj.taxon_ru

  taxon_ru = "Undefined|" if taxon_ru == ""

  taxon_ru += "Авторы>" + product_obj.author.r_quote +  "|" if product_obj.author
  taxon_ru += "Издатели>" + product_obj.publisher.r_quote if product_obj.publisher
  taxon_ru.strip


#-------------------TRANSLATION------------------------------------------

  translation = Booktranslation.find_by(:bookid =>  product_obj.id)

  translation_title = (translation) ? translation.titleen  : ""
  translation_description = (translation) ? translation.descriptionen  : ""

  translation_text = translation_title + ":"  + translation_description
  translation_text = nil if translation_text==":"


  site_id = "_site_" + product_obj.site_id.to_s[-1]
  slug = "book_"  + product_obj.id.to_s + site_id #this is for case when no translation done



  slug=translation_title.gsub(" ","_") + site_id  if translation_title != ""

  isbn = product_obj.isbn +  site_id


  price_rub =   product_obj.price
  price_us =   (product_obj.price / @dollar).to_d.round(2)
  price_euro =   (product_obj.price / @euro).to_d.round(2)



  values =  [ isbn ,product_obj.titleru.gsub("\n"," </br> "), product_obj.descriptionru.gsub("\n"," </br> "),slug,
             translation_description,translation_title,"default", price_us,taxon_ru,taxon_en,"2014-01-01",product_obj.stock_level,image_url,product_properties,translation_text,price_euro,price_rub]

             #stock_level,p.price,p.price,"","general","","", "default"]


  CSV.open(@@config["spree_csv_path"], "a+",{:col_sep => ","}) do |csv|
    csv <<  values
  end
end






def get_exchange_rate


  dollar = nil
  euro =nil


  n_times "Problem with getting exchange rate " do

  now= DateTime.now

      bank_url ="http://www.cbr.ru/scripts/XML_daily.asp?date_req=#{format("%.2i", now.day)}/#{format("%.2i",now.month)}/#{now.year}"
      result =  HTTParty.get(bank_url)

          result["ValCurs"]['Valute'].each do |value|

                   if  value['CharCode']=='USD'
                     dollar =    value['Value']
                   end
                   if  value['CharCode']=='EUR'
                     euro =    value['Value']
                   end
          end

end
  return dollar.gsub(",","."),euro.gsub(",",".")


 end




end



ActiveRecord::Base.logger = Logger.new(STDOUT)




CsvGenerator.new.generate

