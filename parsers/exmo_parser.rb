
require_all 'helpers'

class ExmoParser

  include Helper

  def parse
    Helper.log_and "----- Start_parsing Exmo ! -------"
    get_products



    Helper.log_and "----- parsing Exmo  done ! -------"
  end

  def get_products

    products = []

    response =""
    n_times("Action: Getting first eskmo product xml(100 elements) ") do



      #-------------------- THIS SECTION COMENTED till I will work again on optimization

      # File.delete @@config["exmo_xml"] if (File.exist? @@config["exmo_xml"])
      #
      # open(@@config["exmo_xml"], "wb") do |file|
      #  open(@@config["eksmo_url"] + @@config["eksmo_key"] +"&full=y&action=products") do |remote_f|
      #    file.write(remote_f.read)
      #  end
      # end

      #-------------------------------------END COMENT ---------------------------------------

      response = HTTParty.get(@@config["eksmo_url"] + @@config["eksmo_key"] +"&full=y&action=products")

    end

    pages = response["result"]["pages"].to_obj
   pages.items # total count of items
   pages.all #number of pages

    #extract_products_from_xml @@config["exmo_xml"]
     extract_products(response["result"]["products"]["product"])

    for pag in 2..pages.items.to_i
      n_times(" Getting  eskmo products page #{pag}" ) do
        response = HTTParty.get( @@config["eksmo_url"] + @@config["eksmo_key"] +"&full=y&page=#{pag}&action=products")
       end

       Helper.log_and(" Eskmo getting products from page #{pag} ")
       extract_products(response["result"]["products"]["product"])
    end
  end


  def extract_products array

     content_txt= "__content__"
        hundred_of_products = []
        i = 0
        array.each do |book|
          begin
            i+=1

          product= Product.new
          product.site_id="new_2"
          product.titleru= book['name']
          product.image= book['source_picture'][content_txt] if  book['source_picture'][content_txt].to_s.strip !=""
          product.descriptionru = book['detail_text'][content_txt]

          product.author =  book['cover_authors'][content_txt]

          product.isbn = book['isbnn'][content_txt]
          product.weight =book['brgew'][content_txt]
          product.cover = book['cover'][content_txt]
          product.publisher = book['publi']['name']
          product.price = book['price'][content_txt]
          product.rise_price

          product.pages = book['qtypg'][content_txt]
          product.binding = book['formt']['name']
          product.year = book['ldate_d'][content_txt][-4..-1] if book['ldate_d'][content_txt]
          product.width = book['width'][content_txt]
          product.height = book['height'][content_txt]
          product.stock_level = book['remainder'][content_txt]


         # product.stock_level = book['stock_level'][content_txt] stock level not found


          hundred_of_products << product

            if hundred_of_products.count()==100
              Product.write_product_list hundred_of_products,nil,2
             Helper.log_and " imported : " + i.to_s
            end

          rescue Exception => ex
          Helper.log_and " Exception parsing product exmo product index #{i} exception message: #{ex.message} trace: #{ex.backtrace} "
          end

        end

     Product.write_product_list hundred_of_products,nil,2 if hundred_of_products.count() >0

  end

  def extract_products_from_xml path

    #define auto bindings
    @binding=
        {
            brgew: "weight",
            price: "price",
            isbnn: "isbn",
            width: "width",
            height: "height",
            ldate_d:"year", #NEED CLEANING !!!!
            qtypg: "pages",
            cover_authors: "author",
            name: "titleru",
            detail_text:"descriptionru",
            Currency: "currency",
            source_picture: "image"

            #Barcode: "barcode", #not found
            #Thickness: "thickness", # not found
            #InitialPrintRun:"PrintRun", # not found

#            Format: "Binding", # special
 #           StockLevel:"stock_level" # special

        }


    products_table = []
    imp_count = 0
    started =false
    @reader = XML::Reader.file(path,:options => XML::Parser::Options::NOENT)



    count_products =0
    while(@reader.read)
      begin
      next if  @reader.node_type==15 or @reader.node_type=="#text" or @reader.name=="#text"

      # ---------------------------------------------INSERTED ----------------
      if (@reader.name=="product")

        started=true
        if @product
          @product.year = @product.year.to_s[-4..-1] if @product.year and @product.year.to_s.length >= 4
          @product.rise_price
          products_table << @product
        end

        @product=Product.new
        @product.site_id="new_1"
        next
      end


    next if !started
    get_node if @binding[@reader.name.to_sym]

      #TODO : add SPECIAL CASES

    if products_table.count()==100
      count_products+=100

      Product.write_product_list products_table,@reader,3
      Helper.log_and " imported: " + count_products.to_s
    end
    rescue Exception => ex
    Helper.log_and "Exception file =#{path} message=" +   ex.message.to_s + "trace=" + ex.backtrace.to_s
      end
    end

     Product.write_product_list products_table,@reader,3 if products_table.count() >0
  end

end
