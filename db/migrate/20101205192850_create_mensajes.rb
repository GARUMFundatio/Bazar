class CreateMensajes < ActiveRecord::Migration
  def self.up
    create_table :mensajes do |t|
      t.datetime :fecha
      t.string :tipo
      t.datetime :borrado
      t.datetime :leido
      t.integer :de
      t.integer :para
      t.string :texto
      t.timestamps
    end

    add_index :mensajes, ["de", "fecha"], :name => "index_mensaje_de"
    add_index :mensajes, ["para", "fecha"], :name => "index_mensaje_para"

  end

  def self.down
    drop_table :mensajes
  end
end
