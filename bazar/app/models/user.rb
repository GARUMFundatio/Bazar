class User < ActiveRecord::Base
acts_as_authentic

has_and_belongs_to_many :roles, :join_table => 'roles_users'

def deliver_password_reset_instructions!
  reset_perishable_token!
  Notifier.deliver_password_reset_instructions(self)
end


end
