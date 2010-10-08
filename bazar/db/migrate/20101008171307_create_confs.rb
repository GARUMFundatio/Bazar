class CreateConfs < ActiveRecord::Migration
  def self.up
    create_table :confs do |t|
      t.string :nombre
      t.integer :grupo_id
      t.string :tipo
      t.string :valor
      t.string :desc

      t.timestamps
    end
  end

  def self.down
    drop_table :confs
  end
end
