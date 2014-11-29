class ImageDownloader

  def self.get_images list_of_products


    list_of_products.each do |product|

      next   if !product.imageurl or product.image=="" or !product.image or !product.isbn or  product.isbn =="" or  product.image.strip[-1]=="/"
         if !File.exist?( product.imageurl  )
          begin


           open(product.image.downcase ) do |image_from_url|
              product.isbn = "" if !product.isbn
              product.image = product.image.downcase



             #product.imageurl = path_new_file
             image = Magick::ImageList.new
             image.from_blob(image_from_url.read)

              if (image.y_resolution!= 1024)

                 factor = image.y_resolution/1024
                 y =  (image.y_resolution/ factor).to_i
                 x =  (image.x_resolution/ factor).to_i

                 image1024 = image.resize(x,y)
                 image1024.write product.imageurl
              else
                image.write product.imageurl
              end

           end

         rescue Exception => ex
           puts "Exception could not load image:#{product.image}  Exception message: #{ex.to_s}"
         end

      end
    end

    end

end








