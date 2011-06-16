#!/bin/bash

#
# FUNCIONES
#

prompt()
{
  echo -n "$1 " >&2
  read linea
  echo "$linea"
}

siono()
{
  ok=0
  while [ $ok -eq 0 ] ; do
    lin=`prompt "$1 (S/N):"`
    case $lin in
    S*|s*) return 0 ;;
    N*|n*) return 1 ;;
    *) ;;
    esac
  done
}

instala_mysql()
{
  apt-get -y install mysql-server
}

instala_ruby()
{
  apt-get -y install build-essential zlib1g-dev libssl-dev libreadline5-dev libcurl4-openssl-dev git-core mysql-client libmysqlclient15-dev 
  wget http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.03.tar.gz
  tar zxvf ruby-enterprise-1.8.7-2011.03.tar.gz
   ./ruby-enterprise-1.8.7-2011.03/installer
}

instala_passenger()
{
  /opt/ruby-enterprise-1.8.7-2011.03/bin/passenger-install-nginx-module
}

instala_git()
{
  apt-get -y install git git-core
}

instala_memcache()
{
  apt-get -y install memcached
}


instala_bazar()
{

  if [ -d "/opt/garum/" ]
  then
    echo "Ya existe /opt/garum . No lo creo" 
    existe=1 
  else 
    mkdir -p /opt/garum
    chmod 0777 -R /opt/garum 
    existe=0
  fi


  cd /opt/garum

  if [ $existe -eq 0  ]
  then 
    git clone https://github.com/GARUMFundatio/Bazar.git
    git clone https://github.com/GARUMFundatio/bazarcms.git
  else 
    cd Bazar
    git pull
    cd ../bazarcms
    git pull
  end 

}

#
# MAIN
#

echo "Instalación del Bazar de Garum" 
echo ""
echo "(1) Instalación del Servidor de Base de Datos: mysql"
echo ""

if siono "Instalo Mysql?" ; then
  instala_mysql
fi

echo ""
echo "(2) Instalación Ruby Enterprise"
echo ""

if siono "Instalo Ruby Enterprise?" ; then
  instala_ruby
fi

echo ""
echo "(3) Instalación Apache Passenger"
echo ""

if siono "Instalo Passenger?" ; then
  instala_passenger
fi

echo ""
echo "(4) Instalación Herramienta GIT"
echo ""


if siono "Instalo Git?" ; then
  instala_git
fi

echo ""
echo "(5) Instalación Memcache"
echo ""


if siono "Instalo Memcache?" ; then
  instala_memcache
fi

echo ""
echo "(6) Instalación Aplicación Bazar de Garum"
echo ""


if siono "Instalo Bazar?" ; then
  instala_bazar
fi



