class RenameCapitalColumns < ActiveRecord::Migration
  def change
    rename_column :products, :titleRU, :titleru
    rename_column :products, :Author, :author
    rename_column :products, :Publisher, :publisher
    rename_column :products, :Pages, :pages
    rename_column :products, :descriptionRU, :descriptionrU
    rename_column :products, :PrintRun, :printrun
    rename_column :products, :Year, :year
    rename_column :products, :Binding, :binding
    rename_column :products, :ImageURL, :imageurl
    rename_column :products, :PublicationDate, :publicationdate
    rename_column :products, :AuthorName, :authorname
    rename_column :products, :ReleaseDate, :releasedate

    rename_column :products, :VAT, :vat
    rename_column :products, :Format, :format
    rename_column :products, :SessionID, :sessionid


  end
end

