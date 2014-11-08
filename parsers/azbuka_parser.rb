

class AzbukaParser

  def parse

    # p "open ftp connection to azbuka ftp "
    # ftp = Net::FTP.new( @@config["azbuka_ftp"])
    # ftp.passive=true
    # ftp.login @@config["azbuka_user"],@@config["azbuka_password"]
    #
    # files = ftp.chdir('Prays MMP')
    # p "downloading file from azbuka.ftp "
    # ftp.getbinaryfile('PraysAzbuka-Atticus.xml', @@config['azbuka_xml'] , 1024)
    # ftp.close

     parse_xml (@@config["azbuka_xml"])

  end


  def parse_xml path

    products= []

    #file = File.open(@xml)
    docXML = Nokogiri::XML(File.open(path))

    docXML.css("Product").each do |e|
      p =  Product.new

      p.isbn = docXML.at.css "ProductIdentifier"


      products << p

      @el = e
      #el =XmlElement.new      #el.sku=  e.at("ProductIdentifier").content.strip.to_8
      #el.main_image = e.at("picture").content.strip.to_8 if e.at("picture")
      #el.category_id = e.at("categoryId").content.strip.to_8
      #@xmlElements[el.sku] =el
    end


  end






  def download_file(file)
    BasicSocket.do_not_reverse_lookup = true
    ftp = Net::FTP.new('server', 'user', 'password')
    ftp.passive = true

    begin
      logger.info "info: Downloading #{file}."
      ftp.getbinaryfile(File.basename(file), file, 1024)
    rescue Net::FTPPermError => e
      logger.info "warning: can't download #{File.basename(file)} from the remote server (#{e.message.tr("\n","")})."
    end

    ftp.close

  end


  end