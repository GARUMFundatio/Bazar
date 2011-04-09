class CreateBazarcmsTables5 < ActiveRecord::Migration

  def self.up  
    create_table :perfiles, :force => true do |t|
      t.string   :codigo
      t.string   :desc
      t.integer  :nivel
      t.text     :ayuda
    end

    add_index :perfiles, [:codigo]

    create_table :empresasperfiles, :force => true do |t|
      t.string   :empresa_id
      t.string   :codigo
      t.string   :tipo
    end

    add_index :empresasperfiles, [:empresa_id, :codigo]
  
  end

  def self.down
    
  end

end
