class ImageDownloader

  def self.get_images list_of_products


    list_of_products.each do |product|

         begin
           exension =  product.image.split(".")[-1]

           open(product.image ) do |image_from_url|
              product.isbn = "" if !product.isbn
              path_new_file = @@config["images_dir"] + product.isbn  + "_" + product.id.to_s +  "_" + exension
             if !File.exist?( path_new_file )

                 image = Magick::ImageList.new
                 image.from_blob(image_from_url.read)

                 factor = image.y_resolution/1024
                 y =  (image.y_resolution/ factor).to_i
                 x =  (image.x_resolution/ factor).to_i

                  image1024 = image.resize(x,y)
                  image1024.write path_new_file

                 a =33
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








