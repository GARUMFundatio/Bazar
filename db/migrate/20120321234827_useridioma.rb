class Useridioma < ActiveRecord::Migration
  def self.up
    add_column :users, :idioma, :string
    add_column :users, :alertas, :string
  end

  def self.down
  end
end
