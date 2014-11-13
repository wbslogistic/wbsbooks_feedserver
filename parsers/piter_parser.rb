
class PiterParser

  def parse
    puts "----- Start_parsing Piter ! -------"
    get_files_from_ftp
    get_products
    Product.aprove_new_comers
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


    Dir[ @@config['piter_xml_dir'] + "*.xml"].each do |file|

      file_name= "local_" + file + File.size(file).to_s
      if ParsedFile.where(site_id: 3,file_name: file_name).count()==0
         extract_products_f_xml(file)
      else
         Helper.log_and " File already parsed #{file_name}"
      end
    end
    products
  end


  def extract_products_f_xml path
    products_table = []
    imp_count = 0
   @product = Product.new
   @product.site_id="new_3"

      @reader = XML::Reader.file(path,:options => XML::Parser::Options::NOENT)

  begin

   count_products =0
    while(@reader.read)
      begin
      next if  @reader.node_type==15 or @reader.node_type=="#text"


     if (@reader.name=="Product")
       if @product
         @product.year = @product.year.to_s[0..3] if @product.year and @product.year.to_s.length >= 4
         @product.rise_price
         products_table << @product
       end
       @product=Product.new
       @product.site_id="new_3"
       next
     end
       get_node if @binding[@reader.name.to_sym]

      if products_table.count()==100
        count_products+=100

        Product.write_product_list products_table,@reader,3
        Helper.log_and " imported: " + count_products.to_s
       end
    rescue Exception => ex
     p "Exception file =#{path} " +   ex.to_s + "trace=" + ex.backtrace.to_s
      end
      end

   parsed=  ParsedFile.new
    parsed.site_id= 3
    parsed.file_name= "local_" + path + File.size(path).to_s
    parsed.save

  end
   Product.write_product_list products_table,@reader,3 if products_table.count() >0
end



  def get_files_from_ftp

   Helper.log_and " opening ftp connection to Piter "

   n_times(" Exception during Piter ftp session ") do
   begin
      ftp = Net::FTP.new(@@config["piter_ftp"])
      ftp.passive=true
      ftp.login @@config["piter_user"], @@config["piter_password"]

      files = ftp.list('*.xml')

      p "downloading file from piter  "

      files.each do |f|

        file_name ="Piter" + f.split("Piter")[1]
        n_times(" Exception durring file download from piter file name= #{file_name} ") do
        files =   ParsedFile.where(site_id: '3',file_name: f.to_s).count()

        if files==0

          Helper.delete_if_exists @@config['piter_xml_dir'] + file_name

          Helper.log_and " Download file from Piter. file name= #{file_name}"
          ftp.getbinaryfile(file_name, @@config['piter_xml_dir'] + file_name, 1024)
          Helper.log_and " Download complete! file name= #{file_name}"
          parsed=  ParsedFile.new
          parsed.site_id = 3
          parsed.file_name = f
          parsed.save

        end     end     end

    rescue Exception => ex
      raise "problem during ftp session Piter site " + ex.to_s
   ensure
      Helper.log_and "Closing ftp connection"
     ftp.close
   end
   end

  end


  def get_node
    @product.send(@binding[@reader.name.to_sym] + "=", @reader.read_inner_xml) if !@product.send(@binding[@reader.name.to_sym]) and @reader.read_inner_xml.to_s and @reader.read_inner_xml !=""
  #  b = @binding[@reader.name.to_sym] + "=" +  @reader.read_inner_xml.to_s


  end


end