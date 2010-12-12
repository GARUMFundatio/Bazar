class CreateClusters < ActiveRecord::Migration
  def self.up
    create_table :clusters do |t|
      t.string :nombre
      t.string :desc
      t.string :activo
      t.string :url
      t.string :miclave
      t.string :suclave
      t.integer :empresas

      t.timestamps
    end
  end

  def self.down
    drop_table :clusters
  end
end
