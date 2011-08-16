class CreateBazarcmsTables10 < ActiveRecord::Migration

  def self.up  
    
    add_column :paises, :total_ofertas_bazar, :integer
    add_column :paises, :total_ofertas_mercado, :integer
    add_column :paises, :total_demandas_bazar, :integer
    add_column :paises, :total_demandas_mercado, :integer
    add_column :paises, :empresas, :text
    add_column :paises, :ofertas, :text
    add_column :paises, :demandas, :text

    add_column :perfiles, :total_ofertas_bazar, :integer
    add_column :perfiles, :total_ofertas_mercado, :integer
    add_column :perfiles, :total_demandas_bazar, :integer
    add_column :perfiles, :total_demandas_mercado, :integer
    add_column :perfiles, :empresas, :text
    add_column :perfiles, :ofertas, :text
    add_column :perfiles, :demandas, :text

    rename_column :ofertaspaises, :consulta_id, :oferta_id
    rename_column :ofertasperfiles, :consulta_id, :oferta_id
    
  end

  def self.down
    
  end

end