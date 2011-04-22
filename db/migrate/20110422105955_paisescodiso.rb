class Paisescodiso < ActiveRecord::Migration
  def self.up
	add_column :paises, :cod3, :string
	add_index "paises", ["id"], :name => "index_paises_id"
	add_index "paises", ["codigo"], :name => "index_paises_codigo"
	add_index "paises", ["cod3"], :name => "index_paises_cod3"
  end

  def self.down
  end
end
