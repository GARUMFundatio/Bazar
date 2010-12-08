echo "Instalación de Bazar" 

echo "Compilando las dependencias en el directorio vendor" 

bundle install --path vendor 

echo "Haciendo el setup de bazar" 

echo "Creando Directorio" 
rake bazar:mkdir_dirs 

echo "Permisos Directorio" 
rake bazar:setup_dirs 

echo "Creando usuarios en la BD" 
rake bazar:create_users 
