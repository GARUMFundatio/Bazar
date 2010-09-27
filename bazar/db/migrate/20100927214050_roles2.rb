class Roles2 < ActiveRecord::Migration
  def self.up
    rename_column :roles_users, :role_id, :rol_id
  end 

  def self.down
  end
end
