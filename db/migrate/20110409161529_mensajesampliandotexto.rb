class Mensajesampliandotexto < ActiveRecord::Migration
  def self.up
	change_column :mensajes, :texto, :text
  end

  def self.down
  end
end
