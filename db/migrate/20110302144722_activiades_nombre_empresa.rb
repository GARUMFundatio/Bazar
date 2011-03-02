class ActiviadesNombreEmpresa < ActiveRecord::Migration
  def self.up
    add_column :actividades, :nombre_empresa, :string
  end

  def self.down
  end
end
