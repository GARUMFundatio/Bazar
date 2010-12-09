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
    FileUtils.chown 'www-data', 'www-data', File.join('.','log')
    FileUtils.chown_R 'www-data', 'www-data', File.join('.','public/system')
    FileUtils.chown 'www-data', 'www-data', File.join('config','database.yml')
    FileUtils.chown 'www-data', 'www-data', File.join('config','environment.rb')
  end


end
