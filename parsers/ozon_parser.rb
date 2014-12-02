#
# <offer id="24802704" type="book" available="true">
# <url>http://www.ozon.ru/context/detail/id/24802704/?from=prt_xml_facet</url>
#         <price>232</price>
# <baseprice>232</baseprice>
#         <currencyId>RUR</currencyId>
# <categoryId>1139060</categoryId>
#         <picture>http://www.ozon.ru/multimedia/books_covers/1008520313.jpg</picture>
#         <delivery>true</delivery>
# <orderingTime>
# <ordering>Íà ñêëàäå</ordering>
#         </orderingTime>
# <author>×. Äèêêåíñ, Ä. Ã. Ëîóðåíñ, Ò. Ãàðäè, Ð. Ë. Ñòèâåíñîí</author>
#         <name>Ëó÷øàÿ áðèòàíñêàÿ êîðîòêàÿ ïðîçà / Best British Short Stories (+ CD)</name>
#         <publisher>Ýêñìî</publisher>
# <series>Áèëèíãâà. Ñëóøàåì, ÷èòàåì, ïîíèìàåì</series>
#         <year>2014</year>
# <ISBN>978-5-699-69625-3</ISBN>
#         <language>Ðóññêèé</language>
# <binding>60x90/16</binding>
#         <page_extent>224</page_extent>
# <description>Ñáîðíèê ñîñòîèò èç ðàññêàçîâ è ïîâåñòåé ïðèçíàííûõ ìàñòåðîâ áðèòàíñêîé ëèòåðàòóðû - ×.Äèêêåíñà, Ð.Ë.Ñòèâåíñîíà, Ò.Ãàðäè, Ä.Ã.Ëîóðåíñà. Íåàäàïòèðîâàííûå òåêñòû ïðîèçâåäåíèé äàäóò ÷èòàòåëÿì âîçìîæíîñòü ïî äîñòîèíñòâó îöåíèòü âåëèêîëåïíûé ÿçûê êëàññèêîâ, à ïðåêðàñíûå ïåðåâîäû íà ðóññêèé ïîìîãóò ðàçðåøèòü âîçíèêàþùèå âîïðîñû è òðóäíîñòè. ×èòàÿ è ñëóøàÿ ðàññêàçû íà àíãëèéñêîì ÿçûêå, îáðàùàÿñü ê ïðåêðàñíîìó ïåðåâîäó, âû óëó÷øèòå ñâîè íàâûêè ÷òåíèÿ è âîñïðèÿòèÿ íà ñëóõ èíîÿçû÷íîé ðå÷è. Äëÿ óãëóáëåíèÿ çíàíèé àíãëèéñêîãî è îáëåã÷åíèÿ ïîíèìàíèÿ òåêñòà ïðåäëàãàþòñÿ óïðàæíåíèÿ è ñëîâàðü. Êíèãà áóäåò èíòåðåñíà è ïîëåçíà øêîëüíèêàì, àáèòóðèåíòàì, ñòóäåíòàì, ïðåïîäàâàòåëÿì, à òàêæå âñåì, êòî èçó÷àåò àíãëèéñêèé ÿçûê ñàìîñòîÿòåëüíî èëè ñ ïðåïîäàâàòåëåì. Äëÿ ëèö ñòàðøå 12 ëåò.</description>
# <barcode>9785699696253</barcode>
#       </offer>
# good hash code = Zlib.crc32

class OzonParser

  def parse
    if (File.exist? @@config["ozon_big_xml"] )
       read_ozon_parser(@@config["ozon_big_xml"])
    else
      Helper.log_and " Exception file not found #{@@config["ozon_big_xml"]}"
    end
  end


  def read_ozon_parser path

    @binding=
        {   name: "titleru",
            price: "price",
            categoryId: "category_id",
            currencyId: "currency",
            author: "author",
            picture: "image",
            publisher: "publisher",
            language: "language",
            page_extent: "pages",
            description:"descriptionru",
            barcode: "barcode",
            binding: "binding",
            ISBN:"isbn",
            year: "year"
        }

     products_count= 0
    products_table = []

    t1 = DateTime.now

  #OProduct.delete_all

    @product = OProduct.new
    @product.categories =[]

    @reader = XML::Reader.file(path,:options => XML::Parser::Options::NOENT)

    products_started = false

    list_categories = []
      while(@reader.read)
        begin
        next if  @reader.node_type==15 or @reader.name =="#text"

        if (@reader.name=="category")
           category =  Category.new
           category.name = @reader.read_inner_xml
           category.self_id = @reader.get_attribute("id")
           category.parent_id = @reader.get_attribute("parentId")
           list_categories << category
         next
        end




        if (@reader.name=="offer")

          products_started= true

          Category.save_categories list_categories if list_categories.count > 0

          products_table << @product if @product and @product.product_have_more_2000
          @product=OProduct.new
          @product.categories =[]

          next
        end


        if (@reader.name=="categoryId")
          @product.categories  << @reader.read_inner_xml if @reader.read_inner_xml
        end

        next if  !products_started

        get_node if @binding[@reader.name.to_sym]

        if (@reader.name=="param")

          if @reader.get_attribute("name").force_encoding("UTF-8") == "Тираж".force_encoding("UTF-8")
            @product.printrun = @reader.read_inner_xml
          end
          @product.cover = @reader.read_inner_xml     if @reader.get_attribute("name").force_encoding("UTF-8") == "Тип обложки".force_encoding("UTF-8")
        end



        if products_table.count() == 1000
          Product.write_product_list products_table,@reader,0,false,false,false
            products_count+=1000
            Helper.log_and " imported #{products_count} of books "
        end
        rescue Exception => ex
          @reader.read
          Helper.log_and " Exception on parsing ozon xml " + ex.message.to_s
        end

      end
      t2 = DateTime.now
      Helper.log_and " Database import done! min: #{ ((t2.hour-t1.hour)*60 + t2.min-t1.min)  }"

    Product.write_product_list products_table,@reader,0,false,false,false if products_table.count()>0

  end


  def get_node
    @product.send(@binding[@reader.name.to_sym] + "=", @reader.read_inner_xml) if !@product.send(@binding[@reader.name.to_sym])
  end


end
