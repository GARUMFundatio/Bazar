class MensajesCampos2 < ActiveRecord::Migration
  def self.up
    rename_column :mensajes, :a_nombre, :de_nombre
    rename_column :mensajes, :a_email, :de_email
  end

  def self.down
  end
end
