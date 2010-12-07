class CreateUbicaciones < ActiveRecord::Migration
  def self.up
    create_table :ubicaciones do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ubicaciones
  end
end
