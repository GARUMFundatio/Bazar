class Colores < ActiveRecord::Migration
  def self.up
    add_column :users, :tema, :string
    add_column :users, :temacolor, :string
    add_column :users, :news, :string
    add_column :users, :favoritos, :string
    add_column :users, :correos, :string
  end

  def self.down
  end
end
