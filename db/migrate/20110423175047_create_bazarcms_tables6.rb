class CreateBazarcmsTables6 < ActiveRecord::Migration

  def self.up  

    create_table :ofertas, :force => true do |t|
      t.integer  :bazar_id
      t.integer  :empresa_id
      t.string   :tipo
      t.datetime :fecha
      t.datetime :fecha_hasta
      t.string   :titulo
      t.text     :texto
      t.text     :texto_correo
      t.integer  :vistas
      t.integer  :clicks
      t.integer  :contactos
      t.integer  :fav_empresa
      t.integer  :fav_oferta
      t.integer  :total_empresas
      t.string   :filtro
      t.string   :publica
      t.integer  :cid
      t.datetime :created_at
      t.datetime :updated_at
   end

    add_index :ofertas, [:empresa_id]
    add_index :ofertas, [:fecha]
    add_index :ofertas, [:fecha_hasta]

    create_table :ofertasconsultas, :force => true do |t|
      t.integer  :empresa_id
      t.string   :desc
      t.integer  :total_consultas
      t.integer  :total_respuestas
      t.integer  :total_resultados
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.text     :sql
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :ofertasconsultas, [:empresa_id, :fecha_inicio]

    create_table :ofertasresultados, :force => true do |t|
      t.integer  :ofertasconsulta_id
      t.integer  :cluster_id
      t.integer  :empresa_id
      t.string   :orden
      t.string   :enlace
      t.string   :info
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :ofertasresultados, [:ofertasconsulta_id, :orden]   
    
    create_table :ofertasperfiles, :force => true do |t|
      t.integer  :consulta_id
      t.string   :codigo
      t.string   :tipo
    end

    add_index :ofertasperfiles, [:consulta_id, :codigo]

    create_table :ofertaspaises, :force => true do |t|
      t.integer  :consulta_id
      t.string   :codigo
      t.string   :desc
    end

    add_index :ofertaspaises, [:consulta_id, :codigo]

    create_table :ofertasfavoritos, :force => true do |t|
      t.integer  :bazar_id
      t.integer  :user_id
      t.integer  :empresa_id
      t.datetime :fecha
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :nombre_empresa
      t.string   :titulo_oferta
    end

    add_index :ofertasfavoritos, [:user_id, :fecha]
  
    add_column :perfiles, :total_empresas_bazar, :integer
    add_column :perfiles, :total_empresas_mercado, :integer
    
  end

  def self.down
    
  end

end