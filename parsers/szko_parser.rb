
class SzkoParser

  def parse
     puts ' ----- Start_parsing Szco ! -------'
     url=  @@config["szko"]
     zip_path=  @@config["szko_zip"]
     szko_path = @@config["szko_path"]
     szko_xls = @@config["szko_xls"]


     puts "Getting zip from:#{url}"
    open(zip_path, 'wb') do |file|
      file << open(url).read
    end

     puts ' Unziping #{zip_path}'
    unzip_file(zip_path,szko_path)

     puts ' Unzip done!'


     get_products_from_xls(szko_xls)

     puts ' ---- Szco finished ! ----'
  end



  def  get_products_from_xls(path)
  products = []
  book = Spreadsheet.open path
  sheet1 = book.worksheet 0
    sheet1.each do |row|

      product= Product.new
      product.name =  row[1].to_s
      product.author = row[2].to_s
      product.price = row[4]
      product.rise_price

      product.isbn =  row[10]
      product.barcode= row[10]
      product.editor = row[13]
      product.format = row[15]
      product.cover = row[16]
      product.page_count =  row[17]
      product.description =  row[18]
      products << product
    end

    puts ' ----- all products extracted from Szko ----'

  products

  end



  def unzip_file (file, destination)
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |f|
        f_path=File.join(destination, f.name)
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