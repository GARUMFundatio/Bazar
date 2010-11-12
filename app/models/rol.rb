class Rol < ActiveRecord::Base
  # has_and_belongs_to_many :users
  has_and_belongs_to_many :users, :join_table => 'roles_users'
end
