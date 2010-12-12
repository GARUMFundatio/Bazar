echo "Instalación de Bazar" 

echo "Compilando las dependencias en el directorio vendor" 

bundle install --path vendor 
bundle exec aaf_install
rails generate autocomplete

mkdir -p log 

echo "Haciendo el setup de bazar" 

echo "Creando Directorio" 
rake bazar:mkdir_dirs 

echo "Permisos Directorio" 
rake bazar:setup_dirs 

echo "Creando usuarios en la BD" 
rake bazar:create_users 


echo "Creando las tablas de la base de datos" 
rake db:migrate


