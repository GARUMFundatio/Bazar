class CreateBazarcmsTables7 < ActiveRecord::Migration

  def self.up  

    create_table :ratings, :force => true do |t|
      t.string   :iden
      t.integer  :ori_bazar_id
      t.integer  :ori_empresa_id
      t.string   :ori_empresa_nombre
      t.datetime :ori_fecha
      t.text     :ori_texto
      t.integer  :ori_valor
      t.integer  :des_bazar_id
      t.integer  :des_empresa_id
      t.string   :des_empresa_nombre
      t.datetime :des_fecha
      t.text     :des_texto
      t.integer  :des_valor
      t.string   :token
      t.datetime :created_at
      t.datetime :updated_at
   end

    add_index :ratings, [:iden]
    add_index :ratings, [:ori_empresa_id]
    add_index :ratings, [:ori_fecha]
    add_index :ratings, [:des_empresa_id]
    add_index :ratings, [:des_fecha]

    add_column :empresas, :fax, :string
    add_column :empresas, :telefono, :string
    add_column :empresas, :twitter, :string
    add_column :empresas, :jabber, :string
    add_column :empresas, :rating, :decimal, :default => 0
    add_column :empresas, :total_favoritos, :integer, :default => 0
    add_column :empresas, :total_mostradas, :integer, :default => 0  

    add_column :ofertas, :url, :string 

    add_column :ofertasfavoritos, :oferta_id, :integer 
    
    
    
  end

  def self.down
    
  end

end