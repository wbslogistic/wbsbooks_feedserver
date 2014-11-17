class OProduct < ActiveRecord::Base


  def product_have_more_2000
    begin
      return true if !self.PrintRun

      return false if self.PrintRun.to_i < 2000 and self.PrintRun.to_s.is_number?
    rescue Exception => ex
      return true
    end
    return true
  end




end