
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


  def self.write_product_list_szko list

    write_product_list list,nil, 4 , true,true,false,true
  end


  def self.write_product_list list,reader = nil, site_id =nil , delete=true,write_images=true,aprove_comers=true,szko=false


    #deleting the existing ones
     Product.where(isbn: list.map{|p| p.isbn }.compact ,site_id: site_id.to_s).delete_all if delete

    begin
      #transaction
      Product.transaction do
        list.each do |pr|


          if pr.image and pr.isbn and pr.image.length > 0
          exension =  pr.image.split(".")[-1]
          exension="" if !exension

          path_new_file = @@config["images_dir"] + pr.isbn  + "__" + pr.site_id.to_s.gsub("new","") +  "__." + exension
          pr.imageurl=path_new_file
          end



          pr.save(:validate => false)

          if pr.categories
            pr.categories.each do |cat|
                   Product.connection.execute " INSERT INTO ozon_prod_caty_rel(category_id, book_id)  VALUES ( #{cat}, #{pr.id} ); "
            end
          end


        end
      end

      #ImageDownloader.get_images(list) if write_images
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

     Product.aprove_new_comers if aprove_comers and !szko
     Product.aprove_comers_from_szko  if szko


     #ImageDownloader.get_images(list) if list.count()>0 and write_images
    list.clear
    end

  #
  # ----- GOOD ------
  # --update products T1
  # -- set  category_id= T2.category_id ,  site_id=replace( T1.site_id,'new_','')
  # --FROM o_products  T2
  # ---where T2.isbn=  T1.isbn and  position('new_' in  T1.site_id) > 0 and  T1.site_id<>'new_4' and  T1.isbn is not NULL and  T1.isbn<> '';
  # --commit;
  #
  # --for site 4 GOOOD ------
  # update products T1
  # set  category_id= T2.category_id ,
  #      site_id=replace( T1.site_id,'new_',''),
  #      author=T2.author,
  #      name=T2.name,
  #      year=T2.year,
  #      image=T2.image,
  #      page_count =T2.page_count,
  #      description =T2.description
  #
  # FROM o_products  T2 /*o_product */
  # where T2.isbn=  T1.isbn and  position('new_' in  T1.site_id) > 0 and
  #         T1.site_id='new_4' and  T1.isbn is not NULL and  T1.isbn<> '';
  # commit;



  def self.aprove_new_comers




    begin
    Helper.log_and "Add categories"
    ActiveRecord::Base.connection.execute("update products T1
        set  category_id= T2.category_id,T1.ozon_id = T2.id
        FROM o_products  T2
        where T2.isbn=  T1.isbn and  position('new_' in  T1.site_id) > 0 and  T1.site_id<>'new_4' and  T2.isbn is not NULL and  T2.isbn<> '';
  commit; ")
    Helper.log_and "Categories added"


      rescue Exception => ex
      Helper.log_and "problem with adding categories new commers #{ex.message }"
    end




    begin
      Helper.log_and "Create taxons "

      ActiveRecord::Base.connection.execute <<-SQL
             update products
             set taxon_en = get_taxon_en(category_id),taxon_ru = get_taxon(category_id)
             where isbn is not null and isbn <> '' and  site_id<>'new_4'   and  position('new_' in  site_id) > 0
      SQL

      Helper.log_and "Taxons created "

    rescue Exception=> ex

      Helper.log_and "Exception during taxon creation #{ex.message.to_s} "
    end

    remove_new_flag

    Helper.log_and "Comers are approved "

  end




  def self.aprove_comers_from_szko




    begin
    Helper.log_and "Aprove new comers from szko "
    ActiveRecord::Base.connection.execute <<-SQL
      update products T1
      set  category_id= T2.category_id ,T1.ozon_id = T2.id,
      author=T2.author, titleru=T2.titleru,   year=T2.year,image=T2.image, pages =T2.pages, descriptionru =T2.descriptionru
      FROM o_products  T2
      where T1.isbn= T2.isbn  and T1.site_id='new_4' and  T2.isbn is not NULL and  T2.isbn<> '';
      commit;

      SQL


    Helper.log_and "Comers from SZKO are approved! "


#------------------ TAXON CREATION -------------------

    Helper.log_and "Create taxons "

      ActiveRecord::Base.connection.execute <<-SQL
             update products
             set taxon_en = get_taxon_en(category_id) ,taxon_ru = get_taxon(category_id)
             where site_id='new_4' and isbn is not null;
            commit;
      SQL

      Helper.log_and "Taxons created "



    rescue Exception => ex
    Helper.log_and "problem with sql approving new commers #{ex.message }"
    end

#------------------ REMOVE NEW FLAG  -------------------

    remove_new_flag

  end

  def self.remove_new_flag
    begin
      Helper.log_and " Remove new flag!"

      ActiveRecord::Base.connection.execute <<-SQL
             update products
             set site_id=replace(site_id,'new_','')
             where  position('new_' in  site_id) > 0;
              commit;
      SQL

      Helper.log_and "New flag removed ! "

    rescue Exception=> ex

      Helper.log_and "Exception during taxon creation #{ex.message.to_s} "
    end
  end


  def product_have_more_2000
    begin
    return true if !self.printrun

    return false if self.printrun.to_i < 2000 and self.printrun.to_s.is_number?
    rescue Exception => ex
       return true
    end
    return true
 end


  #azbuka -1
  #exmo   -2
  #piter  -3
  #szko  - 4

end


