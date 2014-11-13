




class AzbukaParser

  def parse
    puts "----- Start_Azbuka parser ! -------"
    getFileFtp
    puts "---- Azbuka start parsing xml -------- "
    parse_with_libxml(@@config["azbuka_xml"])
    Product.aprove_new_comers
  end

  def getFileFtp

   n_times(" Getting files from azbuka ftp ") do
      ftp = Net::FTP.new
      ftp.passive=true
      ftp.connect("178.21.239.3", 21)
      ftp.login(@@config["azbuka_user"], @@config["azbuka_password"])



      time_file = ftp.mtime("/Prays MMP/PraysAzbuka-Atticus.xml").to_s
      time_file="azbuka_" + time_file

      files =   ParsedFile.where(site_id: 1,file_name: time_file.to_s).count()
      if files==0
        Helper.delete_if_exists  @@config['azbuka_xml']
       ftp.getbinaryfile("/Prays MMP/PraysAzbuka-Atticus.xml",@@config['azbuka_xml'])


        parsed=  ParsedFile.new
        parsed.site_id= 1
        parsed.file_name= time_file
        parsed.save

       ftp.close
     end
    end
  end






  def create_azbuka_product
    @product =Product.new
    @product.author=""
    @product.currency= "RUB"
    @product.site_id="new_1"

  end

  def parse_with_libxml path

    if File.exist? path


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
       "MeasureTypeCode"=> {"weight"  => Proc.new {  @reader.read_inner_xml.to_s.strip =="08"},
                            "thickness"  => Proc.new {  @reader.read_inner_xml.to_s.strip =="03"},
                            "height" => Proc.new {  @reader.read_inner_xml.to_s.strip =="01"},
                            "width" =>  Proc.new {  @reader.read_inner_xml.to_s.strip =="02"}}
    }

   create_azbuka_product
     line=0
     count = 0
    while (@reader.read)
      line+=1
        next if  @reader.node_type==15
       if (@reader.name=="Product")
         array_of_products << @product if @product and @product.product_have_more_2000
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
              next if (@reader.read_inner_xml.to_s.strip !="15")
              @product.isbn =  @reader.node.next.next.inner_xml if @reader.node.next and @reader.node.next.next
              next
            rescue
              puts "book without isbn line:" + line.to_s
              next
            end
          when "PriceTypeCode"
            begin
                next if @reader.read_inner_xml.to_s.strip !="01"
                @product.price =  @reader.expand.next.next.inner_xml if @reader.expand.next.next
                @product.rise_price
                next
            rescue Exception => ex
              puts "strange book without price"
              next
            end
            next
          when "MediaFileLink"
            if  !@reader.read_inner_xml.to_s.include? "_small"
                @product.image = @@config["azbuka_image_url"] +  @reader.read_inner_xml.strip if @reader.read_inner_xml.strip !="" if @reader.read_inner_xml.strip !=""
            end
            next
          when "TitleType"
            next if (@reader.read_inner_xml.to_s.strip !="01")
            @product.name= @reader.expand.next.next.inner_xml if  @reader.expand.next.next &&   !@reader.expand.next.next.inner_xml.to_s.empty? && (!@product.name or @product.name.empty?)
          when "NamesBeforeKey"
            @product.author += @reader.read_inner_xml.to_s.strip
           when "KeyNames"
             @product.author =  @reader.read_inner_xml.to_s.strip + " " + @product.author
          else
            next
        end

         if array_of_products.count()==500
           count+=500
           Product.write_product_list array_of_products,@reader,1
           Helper.log_and "imported = " + count.to_s
         end
        end

    Product.write_product_list array_of_products,@reader,1    if array_of_products.count()>0

    else
      Helper.log_and " File not present #{path}"
    end

  end






  def get_node
       if @binding[@reader.name].class.name!= "Hash"
         @product.send(@binding[@reader.name] + "=", @reader.read_inner_xml)
       else

         cont= @reader.expand.next.next.inner_xml.to_s if @reader.expand.next.next
         return if !cont

         @binding[@reader.name].keys.each do |key|
           if (cont and !cont.empty? and @binding[@reader.name][key].call())
             @product.send("#{key}=", cont)
             return
           end
         end
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
      logger.info "warning: can't download #{File.basenme(file)} from the remote server (#{e.message.tr("\n","")})."
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


  #resulted in strange results -
  def parse_with_ox path

    #
    #
    # xml1=    Ox.parse path
    # xml = Ox.parse(path)

    #xml.locate('Element/foo/^Text').each do |t|
    # @data = Model.new(:attr => t)
    #@data.save
    #end

    # or if you need to do other stuff with the element first
    #   xml.locate('Product').each do |elem|
    #     # do stuff
    #     @data = Model.new(:attr => elem.locate('foo/^Text').first)
    #     @data.save
    #   end

  end

  #
  # def get_next_node
  #   @product.price =  @reader.node.next.next.content
  # end

  #square = Proc.new do |n|
  #    n ** 2
  # end





end