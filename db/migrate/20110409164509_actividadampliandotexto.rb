class Actividadampliandotexto < ActiveRecord::Migration
  def self.up
    change_column :actividades, :desc, :text
  end

  def self.down
  end
end
