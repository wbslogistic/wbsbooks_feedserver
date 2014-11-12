class ImageDownloader

  def self.get_images list_of_products


    list_of_products.each do |product|

         begin
          next   if product.image=="" or !product.image or !product.isbn or  product.isbn ==""
           exension =  product.image.split(".")[-1]

           open(product.image.downcase ) do |image_from_url|
              product.isbn = "" if !product.isbn
              product.image = product.image.downcase
              path_new_file = @@config["images_dir"] + product.isbn  + "__" + product.site_id.to_s.gsub("new","") +  "__." + exension

             if !File.exist?( path_new_file )

                 product.image_path = path_new_file
                 image = Magick::ImageList.new
                 image.from_blob(image_from_url.read)


                 factor = image.y_resolution/1024
                 y =  (image.y_resolution/ factor).to_i
                 x =  (image.x_resolution/ factor).to_i

                  image1024 = image.resize(x,y)
                  image1024.write path_new_file
               end
           end
         rescue Exception => ex
           puts "Exception could not load image:#{product.image}  Exception message: #{ex.to_s}"
         end


         # image = Magick::Image.read(self.filename).first
         # image.change_geometry!("640x480") { |cols, rows, img|
         #   newimg = img.resize(cols, rows)
         #   newimg.write("newfilename.jpg")
         # }

    end

    end

end








