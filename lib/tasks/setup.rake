
# tareas iniciales de bazar 

require 'yaml'

namespace :bazar do

  desc "Estableciendo los permisos."

 task :mkdir_dirs do
   FileUtils.mkdir_p File.join('.','public/system/ficheros')
   FileUtils.mkdir_p File.join('.','tmp')
   FileUtils.mkdir_p File.join('.','log')
 end

 task :setup_dirs do
   printf "Cambiando los permisos de los ficheros... ".ljust(75)
   FileUtils.chown 'www-data', 'www-data', File.join('.','tmp')
   FileUtils.chown_R 'www-data', 'www-data', File.join('.','log')
   FileUtils.chmod_R  0666, File.join('.','log')
   FileUtils.chown_R 'www-data', 'www-data', File.join('.','public/system')
   FileUtils.chown 'www-data', 'www-data', File.join('config','database.yml')
   FileUtils.chown 'www-data', 'www-data', File.join('config','environment.rb')
 end

 task :create_users do

 end

 task :db_init do 

   @config = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml"))
#   puts @config.inspect

   puts @config['production']['host']
   puts @config['production']['database']
   puts @config['production']['username']
   puts @config['production']['password']

   host = @config['production']['host']
   database =  @config['production']['database']
   username =  @config['production']['username']
   password =  @config['production']['password']

   if (!host.nil?) 
	system ("mysql -h #{host} -u#{username} -p#{password} #{database} < #{RAILS_ROOT}/ini.sql ")
   else 
	system ("mysql -u #{username} -p#{password} #{database} < #{RAILS_ROOT}/ini.sql")
   end 

 end 


end

