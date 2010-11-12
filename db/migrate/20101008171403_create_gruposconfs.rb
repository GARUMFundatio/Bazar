class CreateGruposconfs < ActiveRecord::Migration
  def self.up
    create_table :gruposconfs do |t|
      t.string :desc

      t.timestamps
    end
  end

  def self.down
    drop_table :gruposconfs
  end
end
