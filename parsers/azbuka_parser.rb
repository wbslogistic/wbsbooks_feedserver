

class AzbukaParser

  def parse

    #getFileFtp todo: uncomment
    parse_with_libxml(@@config["azbuka_xml"])

  end

  def getFileFtp

    p "open ftp connection to azbuka ftp "
    ftp = Net::FTP.new(@@config["azbuka_ftp"])
    begin
    ftp.passive=true
    ftp.login @@config["azbuka_user"], @@config["azbuka_password"]
    files = ftp.chdir('Prays MMP')
    p "downloading file from azbuka.ftp "
    ftp.getbinaryfile('PraysAzbuka-Atticus.xml', @@config['azbuka_xml'], 1024)
    ftp.close
    rescue Exception => ex
    ftp.close
    end
  end





  def create_azbuka_product
    @product =Product.new
    @product.author=""
    @product.currency= "RUB"
  end

  def parse_with_libxml path
    @reader = XML::Reader.file(path)

    array_of_products= []
    @product =nil


   @binding=   {
        "PublisherName" =>  "editor",
        "InitialPrintRun"  => "print_run",
        "NumberOfPages"  => "page_count",
        "NamesBeforeKey"  => "author",
        "PublicationDate"  => "year",
       "SubjectCode" => "subject_code",
       "MeasureTypeCode"=> {"weight"  => Proc.new {  @reader.node.content.to_s.strip =="08"},
                            "thickness"  => Proc.new {  @reader.node.content.to_s.strip =="03"},
                            "height" => Proc.new {  @reader.node.content.to_s.strip =="01"},
                            "width" =>  Proc.new {  @reader.node.content.to_s.strip =="02"}}
    }

   create_azbuka_product
     line=0
    while (@reader.read)
      line+=1
        next if  @reader.node_type==15
       if (@reader.name=="Product")
         array_of_products << @product if @product
         create_azbuka_product
         next
       end

        if @binding[@reader.name]
          get_node
          next
        end

        case @reader.name
          when "ProductIDType"
            begin
              next if (@reader.node.content.to_s.strip !="15")
              @product.isbn =  @reader.node.next.next.content
              next
            rescue
              puts "book without isbn line:" + line.to_s
              next
            end
          when "PriceTypeCode"
            begin
                next if @reader.node.content.to_s.strip !="01"
                @product.price =  @reader.expand.next.next.content if @reader.expand.next.next
                next
            rescue Exception => ex
              puts "strange book without price"
              next
            end
            next
          when "MediaFileLink"
            if  !@reader.node.content.include? "_small"
                @product.image = @@config["azbuka_image_url"] +  @reader.node.content.strip
            end
            next
          when "TitleType"
            next if (@reader.node.content.to_s.strip !="01")
            @product.name= @reader.expand.next.next.content if  @reader.expand.next.next &&   !@reader.expand.next.next.content.empty? && (!@product.name or @product.name.empty?)
          when "NamesBeforeKey"
            @product.author += @reader.node.content.strip
           when "KeyNames"
             @product.author =  @reader.node.content.strip + " " + @product.author
          else
            next
        end



        end

    array_of_products
  end






  def get_node
       if @binding[@reader.name].class.name!= "Hash"
         @product.send(@binding[@reader.name] + "=", @reader.node.content)
       else

         cont= @reader.expand.next.next.content if @reader.expand.next.next
         return if !cont

         @binding[@reader.name].keys.each do |key|
           if (cont and !cont.empty? and @binding[@reader.name][key].call())
             @product.send("#{key}=", cont)
             return
           end
         end
       end

  end

  def get_next_node
    @product.price =  @reader.node.next.next.content
  end

  #square = Proc.new do |n|
#    n ** 2
 # end




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



# this maybe fast should  be checked
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




  #not used
  # def parse_xml path
  #   products= []
  #   docXML = Nokogiri::XML(File.open(path))
  #   docXML.css("Product").each do |e|
  #     p =  Product.new
  #     docXML.css("ProductIdentifier").each do |identifier|
  #     end
  #     products << p
  #     @el = e
  #   end
  #    p " File #{path} parsed !!!"
  # end





end