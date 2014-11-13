class OProduct < ActiveRecord::Base


  def product_have_more_2000
    begin
      return true if !self.print_run

      return false if self.print_run.to_i < 2000 and self.print_run.to_s.is_number?
    rescue Exception => ex
      return true
    end
    return true
  end




end