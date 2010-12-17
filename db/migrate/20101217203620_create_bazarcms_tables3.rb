class CreateBazarcmsTables3 < ActiveRecord::Migration
  def self.up

    create_table :empresasconsultas, :force => true do |t|
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

    add_index :empresasconsultas, [:empresa_id, :fecha_inicio]

    create_table :empresasresultados, :force => true do |t|
      t.integer  :empresasconsulta_id
      t.integer  :cluster_id
      t.integer  :empresa_id
      t.string   :orden
      t.string   :enlace
      t.string   :info
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :empresasresultados, [:empresasconsulta_id, :orden]

  end

  def self.down
    drop_table :empresasconsultas
    drop_table :empresasresultados
    
  end

end