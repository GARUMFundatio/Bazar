set -x
export RAILS_ENV=production

exec 9> deploy.log
exec 1>&9
exec 2>&9

if test -f $1 
then 
	cd $1 

# actualizamos a la última versión

cd ../bazarcms
git pull
cd ../Bazar
git pull 

# hacemos un bundle update 

bundle update --path vendor 

# lanzamos el generate de bazarcms 

rails generate bazarcms -f 

# comprobamos si hay migraciones nuevas

rake db:migrate 

# relanzamos bazar 

touch tmp/restart.txt

# actualizamos la información y enviamos los sitemaps

rake bazar:actualiza
rake sitemap:refresh

else 
	echo "Error: Directorio invalido de instalación!!!!"
fi


cat deploy.log | mail -s "Bazar: deploy.log" deploy@bazarum.com 
cat deploy.log
