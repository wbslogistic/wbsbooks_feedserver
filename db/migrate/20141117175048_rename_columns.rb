


class RenameColumns < ActiveRecord::Migration
  def change

    rename_column :products, :description, :descriptionRU
    rename_column :products, :name, :titleRU
    rename_column :products, :year, :Year


    #`titleRU` text NOT NULL,
    #`descriptionRU` text NOT NULL,
    #`Year` smallint(6) DEFAULT NULL,
    # `Pages` bigint(20) DEFAULT NULL,
    #`Publisher` varchar(45) DEFAULT NULL,
    # author` varchar(45) DEFAULT NULL,
    #`stock_level` varchar(45) DEFAULT NULL,
    #`barcode` varchar(45) DEFAULT NULL,
    #`PrintRun` varchar(45) DEFAULT NULL,
    #`Author` varchar(45) DEFAULT NULL,
    #`Binding` varchar(45) DEFAULT NULL,
  end

end
