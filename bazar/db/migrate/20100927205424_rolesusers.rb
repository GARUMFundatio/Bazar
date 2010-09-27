class Rolesusers < ActiveRecord::Migration
def self.up
create_table :roles_users, :id => false do |t|
t.references :user, :null => false
t.references :role, :null => false
t.timestamps
end
end

def self.down
drop_table :roles_users
end
end
