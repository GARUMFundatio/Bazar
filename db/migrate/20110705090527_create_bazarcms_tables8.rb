class CreateBazarcmsTables8 < ActiveRecord::Migration

  def self.up  
    
    add_column :empresas, :rating_cliente, :decimal, :default => 0
    add_column :empresas, :rating_proveedor, :decimal, :default => 0
    add_column :empresas, :rating_total_cliente, :integer, :default => 0
    add_column :empresas, :rating_total_proveedor, :integer, :default => 0
    
    add_column :ratings, :ori_cliente_plazos, :integer, :default => 0
    add_column :ratings, :ori_cliente_comunicacion, :integer, :default => 0

    add_column :ratings, :ori_proveedor_expectativas, :integer, :default => 0
    add_column :ratings, :ori_proveedor_plazos, :integer, :default => 0
    add_column :ratings, :ori_proveedor_comunicacion, :integer, :default => 0

    add_column :ratings, :des_cliente_plazos, :integer, :default => 0
    add_column :ratings, :des_cliente_comunicacion, :integer, :default => 0

    add_column :ratings, :des_proveedor_expectativas, :integer, :default => 0
    add_column :ratings, :des_proveedor_plazos, :integer, :default => 0
    add_column :ratings, :des_proveedor_comunicacion, :integer, :default => 0
    
    add_column :ratings, :role, :string
    
    
  end

  def self.down
    
  end

end