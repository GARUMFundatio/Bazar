class AsuntoDelMensaje < ActiveRecord::Migration
  def self.up
    add_column :mensajes, :asunto, :string 
  end

  def self.down
  end
end
