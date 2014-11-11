
class PiterParser

  def parse
    puts "----- Start_parsing Piter ! -------"
  #  get_files_from_ftp
    get_products
  end




  def get_products
    @binding=
   {
   Price: "price",
   Title: "name",
	 Author: "author",
   Description:"description",
	 Currency: "currency",
   ReleaseDate:"year",
   Barcode: "barcode",
   ISBN13: "isbn",
   Width: "width",
	 Thickness: "thickness",
   Format: "format",
	 Weight: "weight",
   Pages: "page_count",
   Picture: "image",
	 InitialPrintRun:"print_run",
   StockLevel:"stock_level",
   Height: "height"
   }

    products = []
    Dir[ @@config['piter_xml_dir'] + "*.xml"].each do |file|
     products +=  extract_products_f_xml(file)
    end

  end


  def extract_products_f_xml path
    products_table = []

   @product = Product.new

      @reader = XML::Reader.file(path,:options => XML::Parser::Options::NOENT)

  begin
    while(@reader.read)
      next if  @reader.node_type==15 or @reader.node_type=="#text"


     if (@reader.name=="Product")
       if @product
         @product.year = @product.year.to_s[0..3] if @product.year and @product.year.to_s.length >= 4
         @product.rise_price
         products_table << @product
       end
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


  def get_files_from_ftp

    p "open ftp connection to piter "
    ftp = Net::FTP.new(@@config["piter_ftp"])
    begin
      ftp.passive=true
      ftp.login @@config["piter_user"], @@config["piter_password"]

      files = ftp.list('*.xml')

      p "downloading file from piter  "

      files.each do |f|
        begin
        ftp.getbinaryfile("Piter" + f.split("Piter")[1], @@config['piter_xml_dir'] + "Piter" + f.split("Piter")[1], 1024)
        rescue Exception => ex
          p "Piter exception" + ex.to_s
        end
      end
    rescue Exception => ex
      p ex
    ensure
      p "Closing ftp connection"
     ftp.close
    end
  end


  def get_node
    @product.send(@binding[@reader.name.to_sym] + "=", @reader.node.content) if !@product.send(@binding[@reader.name.to_sym]) and @reader.node.content and @reader.node.content!=""
    b = @binding[@reader.name.to_sym] + "=" +  @reader.node.content.to_s
    a =33

  end


end