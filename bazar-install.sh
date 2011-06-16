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
  apt-get -y install git
}

instala_bazar()
{
  git clone https://github.com/GARUMFundatio/Bazar.git
}

#
# MAIN
#

if siono "Instalo Mysql?" ; then
  instala_mysql
fi

if siono "Instalo Ruby?" ; then
  instala_ruby
fi

if siono "Instalo Passenger?" ; then
  instala_passenger
fi

if siono "Instalo Git?" ; then
  instala_git
fi

if siono "Instalo Bazar?" ; then
  instala_bazar
fi

