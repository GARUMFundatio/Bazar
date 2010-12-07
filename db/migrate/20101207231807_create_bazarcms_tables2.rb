class CreateBazarcmsTables2 < ActiveRecord::Migration
  def self.up
    create_table :ubicaciones, :force => true do |t|
      t.integer  :empresa_id
      t.string   :ciudad_id
      t.text     :desc
      t.datetime  :created_at
      t.datetime  :updated_at
    end

    add_index :ubicaciones, [:empresa_id]
    add_index :ubicaciones, [:ciudad_id]
  end

  def self.down
    drop_table :ubicaciones
  end

end