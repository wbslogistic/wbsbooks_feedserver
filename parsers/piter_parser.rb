
require_all 'helpers'


class PiterParser
  include Helper
  def parse
    puts "----- Start_parsing Piter ! -------"
  #  get_files_from_ftp
    get_products
    Product.approve_new_comers
  end




  def get_products
    @binding=
   {
   Price: "price",
   Title: "titleru",
	 Author: "author",
   Description:"descriptionru",
	 Currency: "currency",
   ReleaseDate:"year",
   Barcode: "barcode",
   ISBN13: "isbn",
   Width: "width",
	 Thickness: "thickness",
   Format: "binding",
	 Weight: "weight",
   Pages: "pages",
   Picture: "image",
	 InitialPrintRun:"printrun",
   StockLevel:"stock_level",
   Height: "height"
   }


    Dir[ @@config['piter_xml_dir'] + "*.xml"].each do |file|

      begin
          file_name= "local_" + file + File.size(file).to_s
          if ParsedFile.where(site_id: 3,file_name: file_name).count()==0
             extract_products_f_xml(file)
          else
             Helper.log_and " File already parsed #{file_name}"
          end
      rescue Exception => ex
        Helper.log_and "Problem with file #{file} + ex #{ex.message.to_s}  trace = #{ex.backtrace} "
      end
    end
  end


  def extract_products_f_xml path
    products_table = []
    imp_count = 0
    started =false
      @reader = XML::Reader.file(path,:options => XML::Parser::Options::NOENT)



   count_products =0
    while(@reader.read)
      begin
      next if  @reader.node_type==15 or @reader.node_type=="#text" or @reader.name=="#text"


     if (@reader.name=="Product")
       started=true
       if @product
         @product.year = @product.year.to_s[0..3] if @product.year and @product.year.to_s.length >= 4
         @product.rise_price
         products_table << @product

         if products_table.count()==100
           count_products+=100

           Product.write_product_list products_table,@reader,3
           Helper.log_and " imported: " + count_products.to_s
         end

       end
       @product=Product.new
       @product.site_id="new_3"
       next
     end

     next if !started
       get_node if @binding[@reader.name.to_sym]


    rescue Exception => ex
     Helper.log_and "Exception file =#{path} message=" +   ex.message.to_s + "trace=" + ex.backtrace.to_s
      end
      end

   parsed=  ParsedFile.new
    parsed.site_id= 3
    parsed.file_name= "local_" + path + File.size(path).to_s
    parsed.save


   Product.write_product_list products_table,@reader,3 if products_table.count() >0
end



  def get_files_from_ftp

   Helper.log_and " opening ftp connection to Piter "

   n_times(" Exception during Piter ftp session ") do
   begin
      ftp = Net::FTP.new(@@config["piter_ftp"])
      ftp.passive=true
      ftp.login @@config["piter_user"], @@config["piter_password"]

      files = ftp.list('*.xml').sort

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

        end
        end
      end

    rescue Exception => ex
      raise "problem during ftp session Piter site #{ex.message} trace = #{ex.backtrace}"
   ensure
      Helper.log_and "Closing ftp connection"
     ftp.close
   end
   end

  end




end