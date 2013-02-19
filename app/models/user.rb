class User < ActiveRecord::Base

acts_as_authentic

has_and_belongs_to_many :roles, :join_table => 'roles_users'

def self.find_by_login_or_email(login)
   find_by_login(login) || find_by_email(login)
end

def deliver_password_reset_instructions!
  reset_perishable_token!
  Notifier.deliver_password_reset_instructions(self)
end

def self.borrarcuenta(id) 

  logger.debug "Borrando usuario: #{id}"
  user = User.find(id) 
  if user.nil? 
    logger.debug "No existe esta cuenta" 
    return 
  end 

  logger.debug "Borramos información de la empresa" 

  compa = Bazarcms::Empresa.find_by_user_id(id) 
  if compa.nil? 
    logger.debug "No existe esta empresa" 
    return 
  else 


  # compa.delete 
  end 

end 

end
