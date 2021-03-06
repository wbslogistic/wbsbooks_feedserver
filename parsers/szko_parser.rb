
class SzkoParser
  include Helper

  def parse
     Helper.log_and  ' ----- Start_parsing Szco ! -------'

     url=  @@config["szko"]
     zip_path=  @@config["szko_zip"]
     szko_path = @@config["szko_path"]
     szko_xls = @@config["szko_xls"]


     n_times("Exception durring getting zip from SZKO") do

       Helper.log_and  "Getting zip from :#{url}"

       begin
     http = Net::HTTP.start("web.szko.ru")
     resp = http.request_head("/prices/priceext.zip")
     file_size = resp['content-length']
     last_modified = resp['last-modified']
     http.finish

       rescue Exception => ex
         Helper.log_and "Problem with szko extraction of mettadata #{url} + ex #{ex.message.to_s}  trace = #{ex.backtrace} "
       end



     if ParsedFile.where(site_id: "4", file_name: zip_path + "_" + last_modified ).count()==0

        Helper.delete_if_exists zip_path # deleting old zip

        begin

        open(zip_path, 'wb') do |file|
          file << open(url).read
        end
        rescue Exception => ex
          Helper.log_and "Problem with download zip  #{url} + ex #{ex.message.to_s}  trace = #{ex.backtrace} "

        end


        begin

        Helper.log_and  " Unziping #{zip_path}"
        unzip_file(zip_path,szko_path)

        new_file=  ParsedFile.new

        new_file.file_name=  zip_path + "_" + last_modified
        new_file.site_id= 4
        new_file.save

        puts ' Unzip done!'

        rescue Exception => ex
        Helper.log_and "Problem with unziping  #{zip_path} + ex #{ex.message.to_s}  trace = #{ex.backtrace} "
       end
     else
       Helper.log_and  zip_path + "_" + last_modified + " already parsed "
     end

     end


     get_products_from_xls(szko_xls)

     Product.approve_comers_from_szko

     puts ' ---- Szco finished ! ----'
  end



  def  get_products_from_xls(path)

    time =  File.mtime(path)
    products = []
    if ParsedFile.where(site_id: 4, file_name: path + time.to_s).count()==0


  begin
      book = Spreadsheet.open path
      sheet1 = book.worksheet 0
  rescue Exception => ex
    Helper.log_and "Problem with opening spreedhet  #{path} + ex #{ex.message.to_s}  trace = #{ex.backtrace} "
    end


      index = 0
      first =true
    sheet1.each do |row|
      begin
        if first
          first =false
          next
        end

      index+=1
      product= Product.new
      product.site_id="new_4"
      product.titleru =  row[1].to_s
      product.author = row[2].to_s
      product.publisher = row[13].to_s.gsub("М.:".force_encoding("UTF-8"),"").gsub("М.:".force_encoding("UTF-8"),"").gsub("СПб.:".force_encoding("UTF-8"),"").strip

      product.price = row[4]
      product.rise_price

      product.stock_level =row[8].to_s.strip
      product.isbn =  row[10]
      product.barcode= row[10]

      product.year = row[14]
      product.binding = row[15]
      product.cover = row[16]
      product.pages =  row[17]
      product.descriptionru =  row[18]
      products << product

     if (products.count()==100)
        Product.write_product_list_szko products
        Helper.log_and " imported : " + index.to_s

       #index+=1
     end
      rescue Exception => ex
        Helper.log_and " Exception on index: #{index} ex=#{ex.message} trace =#{ex.backtrace.to_s}"
      end
    end


      parsed=  ParsedFile.new
      parsed.site_id = 4
      parsed.file_name = path + time.to_s
      parsed.save

    else
      Helper.log_and " file already parsed: " +  path + time.to_s
    end
       Product.write_product_list_szko products if products.count() >0
   end


  def unzip_file (file, destination)

    #destination =  File.join(destination, f.name)
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path=File.join(destination, f.name)

        Helper.delete_if_exists f_path

        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
  end




  # def  get_products_from_xls3(path)
  #
  #   s = Roo::Excel.new(path)
  #
  #   s.first_row.upto(s.last_row) do |line|
  #     product= Product.new
  #     name = s.cell(line, 1)
  #   end
  #
  #
  #
  # end


  # def get_products_from_xls(path)
  #
  #   s = SimpleSpreadsheet::Workbook.read(path)
  #   s.selected_sheet = s.sheets.first
  #
  #   products =[]
  #   s.first_row.upto(s.last_row) do |line|
  #     product= Product.new
  #
  #     name = s.cell(line, 1, 1)
  #     second = s.cell(line, 3, 1)
  #
  #   end
  #
  #
  #   p ' getting products finished'
  #
  # end

  #
  # def get_products_from_xlsOld2(path)
  #   creek = Creek::Book.new path
  #   sheet= creek.sheets[0]
  #
  #   sheet.rows.each do |row|
  #     puts row # => {"A1"=>"Content 1", "B1"=>nil, C1"=>nil, "D1"=>"Content 3"}
  #   end
  #
  #
  #
  # end


  end