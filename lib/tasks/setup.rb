namespace :bazar do

  desc "Estableciendo los permisos."

  task :Setup_dirs do
    printf "Cambiando los permisos de los ficheros... ".ljust(75)
    FileUtils.chown 'www-data', 'www-data', File.join('.','tmp')
    FileUtils.chown 'www-data', 'www-data', File.join('.','log')
    FileUtils.chown_R 'www-data', 'www-data', File.join('.','public/system')
    FileUtils.chown 'www-data', 'www-data', File.join('config','database.yml')
    FileUtils.chown 'www-data', 'www-data', File.join('config','environment.rb')
  end

  task :mkdir_dirs do
    FileUtils.mkdir_p File.join('.','public/system/ficheros')
  end

  desc "Crea los usuarios y los permisos para la base de datos"
  task :create_users do
    db_config = YAML::load_file(File.join('config', 'database.yml'))
    db_user = db_config['production']["username"]
    db_passwd = db_config['production']["password"]
    for database in db_config.collect {|i|i.last['database']}.compact do
      system %Q<echo "GRANT ALL PRIVILEGES ON #{database}.* TO '#{db_user}'@'localhost' identified by '#{db_passwd}';" | mysql -u root>
    end
  end

end