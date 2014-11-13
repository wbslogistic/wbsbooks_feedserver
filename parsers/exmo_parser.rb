class ExmoParser

  def parse
    puts "----- Start_parsing Exmo ! -------"
    get_products
    Product.aprove_new_comers
  end

  def get_products

    products = []

    response =""
    n_times("Action: Getting first eskmo product xml(100 elements) ") do
      response = HTTParty.get("https://partners.eksmo.ru/wservices/xml/v1/?key=#{@@config["eksmo_key"]}&action=products_full&full=y")
#
    end

    pages = response["result"]["pages"].to_obj
   pages.items # total count of items
   pages.all #number of pages

     extract_products(response["result"]["products"]["product"])

    for pag in 2..pages.items.to_i
      n_times(" Getting  eskmo products page #{pag}" ) do
        response = HTTParty.get(  "https://partners.eksmo.ru/wservices/xml/v1/?key=#{@@config["eksmo_key"]}&action=products_full&full=y&page=#{pag}")
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
          product.name= book['name']
          product.image= book['source_picture'][content_txt] if  book['source_picture'][content_txt].strip !=""
          product.description = book['detail_text'][content_txt]

          product.author =  book['cover_authors'][content_txt]

          product.isbn = book['isbnn'][content_txt]
          product.weight =book['brgew'][content_txt]
          product.cover = book['cover'][content_txt]
          product.editor = book['publi'][content_txt]
          product.price = book['price'][content_txt]
          product.rise_price

          product.page_count = book['qtypg'][content_txt]
          product.format = book['formt']['name']
          product.year = book['ldate_d'][content_txt]
          product.width = book['width'][content_txt]
          product.height = book['height'][content_txt]

          hundred_of_products << product

            if hundred_of_products.count()==100
              Product.write_product_list hundred_of_products,nil,2
             Helper.log_and " imported : " + i.to_s
            end

          rescue Exception => ex
          Helper.log_and " Exception parsing product exmo product index #{i} "
          end

        end

     Product.write_product_list hundred_of_products,nil,2 if hundred_of_products.count() >0

  end

end
