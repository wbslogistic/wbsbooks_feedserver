class OProduct < ActiveRecord::Base


  def product_have_more_2000
    begin
      return true if !self.printrun

      return false if self.printrun.to_i < 2000 and self.printrun.to_s.is_number?
    rescue Exception => ex
      return true
    end
    return true
  end


  attr_accessor :categories



end