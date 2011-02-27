class MensajesCampos < ActiveRecord::Migration
  def self.up
	add_column :mensajes, :a_email, :string
	add_column :mensajes, :a_nombre, :string
	add_column :mensajes, :para_email, :string
	add_column :mensajes, :para_nombre, :string
  end

  def self.down
  end
end
