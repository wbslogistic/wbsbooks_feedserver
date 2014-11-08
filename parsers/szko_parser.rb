
class SzkoParser

  def parse
     p 'start_parsing'
     url=  @@config["szko"]
     zip_path=  @@config["szko_zip"]
     szko_path = @@config["szko_path"]
     szko_xls = @@config["szko_xls"]


    p "Getting zip from:#{url}"
    open('zip_path', 'wb') do |file|
      file << open(url).read


    end

    p ' Unziping #{zip_path}'
    unzip_file(zip_path,szko_path)

     p ' Unzip done!'

     get_products_from_xls(szko_xls)

  end



  def  get_products_from_xls(path)
  products = []
  book = Spreadsheet.open path
  sheet1 = book.worksheet 0
    sheet1.each do |row|

      p= Product.new
      p.name =  row[1].to_s
      p.author = row[2].to_s
      p.price = row[4]
      p.isbn =  row[10]
      p.barcode= row[10]
      p.editor = row [13]
      p.format = row [16]
      p.cover = row [16]
      p.page_count =  row [17]
      products << p
    end

    p 'all products extracted from Szko'


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

  # def unzip_file (file, destination)
  #   Zip::ZipFile.open(file) do |zip_file|
  #     zip_file.each do |f|
  #       f_path=File.join(destination, f.name)
  #       FileUtils.mkdir_p(File.dirname(f_path))
  #       zip_file.extract(f, f_path) unless File.exist?(f_path)
  #     end
  #   end
  # end

  end