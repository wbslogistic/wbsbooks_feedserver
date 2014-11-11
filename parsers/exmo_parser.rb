class ExmoParser

  def parse
    puts "----- Start_parsing Exmo ! -------"
    get_products
  end

  def get_products

    products = []

    response = HTTParty.get("https://partners.eksmo.ru/wservices/xml/v1/?key=#{@@config["eksmo_key"]}&action=products_full&full=y")

    pages = response["result"]["pages"].to_obj
   pages.items # total count of items
   pages.all #number of pages

    products+=extract_products(response["result"]["products"]["product"])

    for pag in 2..pages.items.to_i
        response = HTTParty.get(  "https://partners.eksmo.ru/wservices/xml/v1/?key=#{@@config["eksmo_key"]}&action=products_full&full=y&page=#{pag}")
      products+=extract_products(response["result"]["products"]["product"])
    end
    products
  end


  def extract_products array

     content_txt= "__content__"
        hundred_of_products = []
        array.each do |book|
          product= Product.new
          product.name= book['name']
          product.image= book['source_picture'][content_txt]
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
        end
     hundred_of_products
  end

end
