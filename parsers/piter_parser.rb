class PiterParser

  def parse
    get_products
  end


  def get_node
        @product.send(@binding[@reader.name.to_sym] + "=", @reader.node.content)
  end




  def get_products
    @binding=
   {
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
   StockLevel:"stock_level"
   }

    products = []
    Dir[ @@config['piter_xml_dir'] + "*.xml"].each do |file|
     products +=  extract_products(file)
    end

  end


  def extract_products path
    products_table = []

   @product = Product.new

      @reader = XML::Reader.file(path)
    while(@reader.read)
      next if  @reader.node_type==15

     if (@reader.name=="Product")
       products_table << @product if @product
       @product=Product.new
       next
     end
       get_node if @binding[@reader.name.to_sym]
    end

  end


  def getFileFtp

    p "open ftp connection to piter "
    ftp = Net::FTP.new(@@config["piter_ftp"])
    begin
      ftp.passive=true
      ftp.login @@config["piter_user"], @@config["piter_password"]

      files = ftp.list('*.xml')

      p "downloading file from piter  "

      files.each do |f|
        ftp.getbinaryfile("Piter" + f.split("Piter")[1], @@config['piter_xml_dir'] + "Piter" + f.split("Piter")[1], 1024)
        #ftp.getbinaryfile('PraysAzbuka-Atticus.xml', @@config['azbuka_xml'], 1024)
      end
    rescue Exception => ex
      p ex
    ensure
      p "Closing ftp connection"
     ftp.close
    end
  end



end