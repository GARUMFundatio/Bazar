class CreateBazarcmsTables4 < ActiveRecord::Migration
  def self.up
    add_column :empresas, :url, :string
  end

  def self.down
    
  end

end


