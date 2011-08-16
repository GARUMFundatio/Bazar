class CreateBazarcmsTables9 < ActiveRecord::Migration

  def self.up  
    
    add_column :ofertasresultados, :oferta_id, :integer
    add_column :ofertasresultados, :tipo, :string
    add_column :ofertasresultados, :nombre_empresa, :string
    
    add_index :ofertasresultados, [:orden]
  end

  def self.down
    
  end

end