class Estadisticasconsultas < ActiveRecord::Migration
  def self.up
    create_table :estadisticasconsultas do |t|
      t.datetime :fecha
      t.integer :bazar_id
      t.integer :empresa_id
      t.integer :empresas
      t.string :consulta
      t.string :tipo 
    end
  end

  def self.down
  end
end
