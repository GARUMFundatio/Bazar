class CreateActividades < ActiveRecord::Migration
  def self.up
    create_table :actividades do |t|
      t.integer :bazar_id
      t.integer :user_id
      t.integer :local_id
      t.datetime :fecha
      t.string :desc
      t.string :tipo

      t.timestamps
    end
      add_index "actividades", ["fecha"], :name => "index_actividad_fecha"
  end

  def self.down
    drop_table :actividades
  end
end
