class CreateFavoritos < ActiveRecord::Migration
  def self.up
    create_table :favoritos do |t|
      t.integer :bazar_id
      t.integer :user_id
      t.integer :empresa_id
      t.datetime :fecha

      t.timestamps
    end
  end

  def self.down
    drop_table :favoritos
  end
end
