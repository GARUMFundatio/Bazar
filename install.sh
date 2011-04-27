echo "Instalación de Bazar" 




echo "Compilando las dependencias en el directorio vendor" 

bundle install --path vendor 
bundle exec aaf_install

RAILS_ENV=production rails generate delayed_job
RAILS_ENV=production rails generate bazarcms 

mkdir -p log 

echo "Haciendo el setup de bazar" 

echo "Creando Directorio" 
RAILS_ENV=production rake bazar:mkdir_dirs 

echo "Permisos Directorio" 
RAILS_ENV=production rake bazar:setup_dirs 

echo "Creando usuarios en la BD" 
RAILS_ENV=production rake bazar:create_users 

echo "Instalando jquery" 
RAILS_ENV=production rails generate jquery:install

echo "Instalando friendly_id" 
RAILS_ENV=production rails generate friendly_id

echo "Creando las tablas de la base de datos" 
RAILS_ENV=production rake db:migrate

RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Cluster
RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Bazarcms:Empresa
RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Bazarcms:Oferta
RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Pais
RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Ciudad
RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Bazarcms::Perfil
RAILS_ENV=production rake friendly_id:redo_slugs MODEL=Bazarcms::Perfil

echo "Actualizando la información del resto de los bazares" 
RAILS_ENV=production rake bazar:actualiza


