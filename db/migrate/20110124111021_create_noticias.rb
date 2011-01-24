class CreateNoticias < ActiveRecord::Migration
  def self.up
    create_table :noticias do |t|
      t.text :titulo
      t.text :texto
      t.datetime :fecha
      t.integer :visible

      t.timestamps
    end
    add_index "noticias", ["fecha"], :name => "index_noticia_fecha"
  end

  def self.down
    drop_table :noticias
  end
end
