class AddValidationColumns < ActiveRecord::Migration
  def change
    add_column :products , :PublicationDate , :string
    add_column :products , :ReleaseDate , :string
    add_column :products , :AuthorName , :string
    add_column :products , :VAT , :decimal
    add_column :products , :rrp , :string
    add_column :products , :ozon_id , :integer
    add_column :products , :source , :string
    add_column :products , :source_id , :string
    add_column :products , :Format , :string
    add_column :products , :SessionID , :string
    add_column :products , :Confirmed , :integer
    add_column :products , :old_id , :integer

  end
end

