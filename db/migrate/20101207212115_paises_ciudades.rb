class PaisesCiudades < ActiveRecord::Migration
  def self.up

    create_table "ciudades", :force => true do |t|
      t.string   "descripcion",              :default => "", :null => false
      t.integer  "pais_id",                                  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.float    "latitud"
      t.float    "longitud"
      t.string   "geocode"
      t.string   "pais_codigo", :limit => 2
    end

    add_index "ciudades", ["pais_id"], :name => "index_ciudades_pais_id"

    create_table "paises", :force => true do |t|
      t.string   "descripcion", :limit => 100, :null => false
      t.string   "codigo",      :limit => 2,   :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "capital"
    end

    add_index "paises", ["codigo"], :name => "index_paises_codigo_pais_id"

  end

  def self.down
  end
end
