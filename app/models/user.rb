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

  User.where(:id => id).destroy_all
  Bazarcms::Empresa.where(:user_id => id).destroy_all
  Bazarcms::Empresasconsulta.where(:empresa_id => id).destroy_all
  Bazarcms::Empresasdato.where(:empresa_id => id).destroy_all
  Bazarcms::Empresasimagen.where(:empresa_id => id).destroy_all
  Bazarcms::Empresasperfil.where(:empresa_id => id).destroy_all
  Favorito.where(:empresa_id => id).destroy_all
  Bazarcms::Oferta.where(:empresa_id => id).destroy_all
  Bazarcms::Ofertasconsulta.where(:empresa_id => id).destroy_all
  Bazarcms::Ubicacion.where(:empresa_id => id).destroy_all

end 

end
