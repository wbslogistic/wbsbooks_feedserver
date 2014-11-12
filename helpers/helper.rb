class Helper

  def self.round_price product
     if product.price and product.price.length > 0
       return (product.price.gsub(",",".").to_f * 1.8).round(2)
     end
    product.price
  end


  def self.log text
    open('./log/product.log', 'a') { |f|
      f.puts DateTime.now.to_s + "   " + text
    }
  end


  def self.log_and text
    puts text
    log text
  end

end