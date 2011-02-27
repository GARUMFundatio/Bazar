class CorreoBazares < ActiveRecord::Migration
  def self.up
    add_column :mensajes, :bazar_origen, :integer
    add_column :mensajes, :bazar_destino, :integer
  end

  def self.down
  end
end
