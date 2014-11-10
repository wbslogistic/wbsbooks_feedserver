

class AzbukaParser

  def parse
  
    # temporary comented 
    # p "open ftp connection to azbuka ftp "
    # ftp = Net::FTP.new( @@config["azbuka_ftp"])
    # ftp.passive=true
    # ftp.login @@config["azbuka_user"],@@config["azbuka_password"]
    #
    # files = ftp.chdir('Prays MMP')
    # p "downloading file from azbuka.ftp "
    # ftp.getbinaryfile('PraysAzbuka-Atticus.xml', @@config['azbuka_xml'] , 1024)
    # ftp.close

    parse_with_libxml(@@config["azbuka_xml"])
    #parse_xml (@@config["azbuka_xml"])

  end


  def parse_xml path
    products= []
    docXML = Nokogiri::XML(File.open(path))
    docXML.css("Product").each do |e|
      p =  Product.new
       docXML.css("ProductIdentifier").each do |identifier|
     end
      products << p
      @el = e
    end
    p "parsed"
  end



  def parse_with_libxml path
    reader = XML::Reader.file(path)
    while (reader.read())
      if (reader.name=="Product")
         p= Product.new
        reader.expand.children.each do |child|

        if (child.name=="ProductIdentifier")
           product_id_type = child.children.find do |child2| child2.name=="ProductIDType"  end

           content_strippep =""
           content_stripped=product_id_type.content_stripped  if product_id_type
            if ( content_stripped=="15")
              child.find do |child3|
               if (child3.name=="IDValue")
                p.barcode =  child3.content_stripped
              end
            end

        end
         value =  child.children.find do |subElement3| subElement3.name=="IDVALUE" end.content_stripped
        end
        end
        end

     p reader.to_s


    end

    end
    end


  #resulted in strange results -
  def parse_with_ox path



  xml1=    Ox.parse path


  xml = Ox.parse(path)

  #xml.locate('Element/foo/^Text').each do |t|
   # @data = Model.new(:attr => t)
    #@data.save
  #end

# or if you need to do other stuff with the element first
  xml.locate('Product').each do |elem|
    # do stuff
    @data = Model.new(:attr => elem.locate('foo/^Text').first)
    @data.save
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