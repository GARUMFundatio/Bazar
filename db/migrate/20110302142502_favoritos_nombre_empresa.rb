class FavoritosNombreEmpresa < ActiveRecord::Migration
  def self.up
    add_column :favoritos, :nombre_empresa, :string
  end

  def self.down
  end
end
