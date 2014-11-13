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

def get_ex ex,messaga
  "exception :#{}  message #{ex.message} #{ex.backtrace.to_s}"
end

  def self.log_and text
    puts text
    log text
  end


  def self.delete_if_exists file
   File.delete(file) if File.exist? file
  end



end



class String
  def is_number?
    true if Float(self) rescue false
  end
end


