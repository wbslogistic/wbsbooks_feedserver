class Category < ActiveRecord::Base


  def self.save_categories list
    #Category.destroy_all
    #deleting the existing ones

    begin
      #transaction
      Category.transaction do
        list.each do |cat|
          cat.save(:validate => false)
        end
      end

    rescue Exception => ex
      Helper.log_and " Exception on saving category : " + ex.message + " trace = " + ex.backtrace.to_s
      list.clear
      list=nil
      return
    end
    Helper.log_and " #{list.count} Categories imported from OZON !!! "
    list.clear
    list=nil

    Helper.log_and " #Generate taxons !!! "

    Category.connection.execute <<-SQL
                                              UPDATE categories
                                               SET taxon_en=get_taxon_en(self_id), taxon_ru=get_taxon(self_id);
                                    SQL

    Helper.log_and "Taxons generated !!! "

  end

end


