class User < ActiveRecord::Base
acts_as_authentic

has_and_belongs_to_many :roles, :join_table => 'roles_users'

end
