require './add_things'
require 'csv'


class String
  def r_quote()
    replace (self.gsub("&quot;"," "))
  end

  def remove_publisher_prefix
    replace (self.gsub("&quot;","''").gsub("М.:".force_encoding("UTF-8"),"").gsub("М.:".force_encoding("UTF-8"),"").strip)
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
  columns= "sku,name,description,slug,meta_description,meta_keywords,shipping_category_id,price,taxons_ru,Taxons,Available On,stock,product_properties,translation,price_eu,price_ru,Images".split(",")
     Helper.delete_if_exists @@config["spree_csv_path"]
    CSV.open(@@config["spree_csv_path"] , "w",{:col_sep => ","}) do |csv|
      csv << columns
    end
end




#SKU	Name	Description	Available On	Price	CostPrice	product_properties	Taxons	OptionTypes	Variants	count_on_hand

def  write_to_csv product_obj , i
  return if !product_obj

     stock_level = "2014-09-09" if  product_obj.stock_level and  product_obj.stock_level!='' and product_obj.stock_level.to_i > 0

  image_url= ""

  image_url = File.exist?(product_obj.imageurl) ?  "public/" + product_obj.imageurl[2..-1] : nil if product_obj.imageurl

  #------------------- PROPERTIES ------------------------------------------

  product_properties = ""
  product_properties += "Publisher:" + product_obj.publisher.to_s.remove_publisher_prefix   + ";"
  product_properties += "publication_year:" + product_obj.year.to_s.gsub("&quot;","''")+ ";"  if product_obj.year
  product_properties += "ISBN:" + product_obj.isbn.to_s + ";" if product_obj.isbn

  product_properties += "HEIGHT:" + product_obj.height.to_s  + ";" if product_obj.height
  product_properties += "WIDTH:" + product_obj.width.to_s + ";" if product_obj.width
  product_properties += "WEIGHT:" + product_obj.weight.to_s + ";" if product_obj.weight

  product_properties += "DEPTH:" + product_obj.thickness.to_s + ";" if product_obj.thickness
  product_properties += "Format:" + product_obj.binding.to_s  + ";" if product_obj.binding
  product_properties += "in_stock:" + product_obj.stock_level.to_s  + ";" if product_obj.stock_level
  product_properties += "Pages:" + product_obj.pages.to_s  + ";" if product_obj.pages



  product_obj.publisher=  product_obj.publisher.to_s.remove_publisher_prefix
  product_properties= product_properties.gsub(";","|")


#-------------------TAXONS------------------------------------------

  #taxons ="Categories>Business books|"


  categories_rel=[]
  if !product_obj.ozon_id.blank?
        categories_rel = ActiveRecord::Base.connection.execute <<-SQL
      select *
      from ozon_prod_caty_rel
      where book_id = '#{product_obj.ozon_id}'
    SQL

  end




categories = categories_rel.map do  |rel|;  Category.find_by(:self_id =>  rel['category_id']) ; end


  taxon_en = ""
  taxon_ru = ""
   categories.each do |category|
     taxon_en += "Categories>" + category.taxon_en + "|"
     taxon_ru += "Categories>" + category.taxon_ru + "|"
  end.join


   taxon_en = "Undefined|" if taxon_en == ""
   taxon_ru = "Undefined|" if taxon_ru == ""


#-------------------- AUTHORS -------------------------------------


  author =  !product_obj.author_id.blank?  ?  Author.where(:authorid => product_obj.author_id).first : nil


  author_ru_name = author  ?   author.authorru : product_obj.author
  author_en_name = author  ?   author.authoren : product_obj.author

  taxon_en += "Authors>" + author_en_name +  "|" if !author_en_name.blank?
  taxon_ru += "Авторы>" + author_ru_name +  "|" if !author_ru_name.blank?


  #
  # publishers_id=[]
  # if !product_obj.ozon_id.blank?
  #   publishers_id = ActiveRecord::Base.connection.execute <<-SQL
  #      SELECT bookid, publisherid
  #      FROM bookpublishers;
  #      WHERE book_id = '#{product_obj.ozon_id}'
  #   SQL
  # end



  #categories = categories_rel.map do  |rel|;  Category.find_by(:self_id =>  rel['category_id']) ; end
  #publishers_id.each do |pub|
  #  end

  taxon_en += "Publishers>" + product_obj.publisher.r_quote if product_obj.publisher and  product_obj.publisher!=''
  taxon_ru += "Издатели>" + product_obj.publisher.r_quote if product_obj.publisher and product_obj.publisher!=''



  taxon_en.strip
  taxon_ru.strip


#-------------------TRANSLATION------------------------------------------

  translation = Booktranslation.find_by(:bookid =>  product_obj.id)

  translation_title = (translation) ? translation.titleen  : ""
  translation_description = (translation) ? translation.descriptionen  : ""


  translation_title= product_obj.titleru if translation_description==""
  translation_description =  product_obj.descriptionru if translation_description==""



  translation_text = translation_title + "-:-"  + translation_description

  translation_text = product_obj.titleru.to_s + "-:-"  + product_obj.descriptionru.to_s + "" if translation_text==":"

  translation_text += "-:-" + product_obj.titleru.to_s  +  "-:-" + product_obj.descriptionru.to_s


  # translation should be taken from different place




  site_id = "_site_" + product_obj.site_id.to_s[-1]
  slug = "book_"  + product_obj.id.to_s + site_id #this is for case when no translation done



  slug=translation_title.gsub(" ","_") + site_id  if translation_title != ""

  isbn = product_obj.isbn +  site_id


  price_rub =   product_obj.price
  price_us =   (product_obj.price / @dollar).to_d.round(2)
  price_euro =   (product_obj.price / @euro).to_d.round(2)



  values =  [ isbn ,product_obj.titleru.to_s.gsub("\n"," </br> "), product_obj.descriptionru.to_s.gsub("\n"," </br> "),slug,
             translation_description,translation_title,"default", price_us,taxon_ru,taxon_en,"2014-01-01",product_obj.stock_level,product_properties,translation_text,price_euro,price_rub,product_obj.image]  #image_url]

             #stock_level,p.price,p.price,"","general","","", "default"]


  CSV.open(@@config["spree_csv_path"], "a+",{:col_sep => ","}) do |csv|
    csv <<  values
  end
end






  def get_exchange_rate
    return       56,70
  end


def get_exchange_rate_old


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

  return     56,70     #dollar.gsub(",","."),euro.gsub(",",".")
 end




end



ActiveRecord::Base.logger = Logger.new(STDOUT)




CsvGenerator.new.generate

