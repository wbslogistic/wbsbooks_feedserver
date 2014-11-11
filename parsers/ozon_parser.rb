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

class OzonParser

  def parse
    read_ozon_parser(@@config["ozon_big_xml"])
  end


  def read_ozon_parser path

    @binding=
        {   name: "name",
            price: "price",
            categoryId: "category_id",
            currencyId: "currency",
            author: "author",
            picture: "image",
            publisher: "editor",
            language: "language",
            page_extent: "page_count",
            description:"description",
            barcode: "barcode",
            binding: "format",
            ISBN:"isbn",
            year: "year"
        }
    products_table = []

    @product = Product.new

    @reader = XML::Reader.file(path,:options => XML::Parser::Options::NOENT)

    begin
      while(@reader.read)
        next if  @reader.node_type==15 or @reader.name =="#text"

        if (@reader.name=="offer")
          #products_table << @product if @product
          @product=Product.new

          next
        end
        get_node if @binding[@reader.name.to_sym]
      end
    rescue Exception => ex
      p "Exception file =#{path} " +   ex.to_s
    end
    @reader


    products_table
  end


  def get_node
    @product.send(@binding[@reader.name.to_sym] + "=", @reader.node.content) if !@product.send(@binding[@reader.name.to_sym])
  end



end