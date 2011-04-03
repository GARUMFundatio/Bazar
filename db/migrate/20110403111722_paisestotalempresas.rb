class Paisestotalempresas < ActiveRecord::Migration
  def self.up
	add_column :paises, :total_empresas_bazar, :integer
	add_column :paises, :total_empresas_mercado, :integer
	add_column :ciudades, :total_empresas_bazar, :integer
	add_column :ciudades, :total_empresas_mercado, :integer
  end

  def self.down
  end
end
