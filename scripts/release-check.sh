#!/bin/bash  
direc="bouquet-core bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql bouquet-plugin-redshift bouquet-plugin-teradata bouquet-server bouquet-parent";
dirprivate="bouquet-plugin-oracle squid-v4-tests obs-tests";
alldirs="$direc $dirprivate";

version="$1"
nextver="$2"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


if [ -z "$version" ]
  then
  	echo "No version name"
    echo usage: $0 version next-version workdir
    exit
fi
if [ -z "$nextver" ]
  then
  	echo "No next version name"
    echo usage: $0 version next-version workdir
    exit
fi

workdir="$3";
if [ -z $workdir ]
  then
  	workdir="/tmp";
fi


current_time=$(date "+%Y.%m.%d-%H")
workdir=$workdir/release.$current_time;

echo "workdir : $workdir";
cd $workdir;

for i in $alldirs
do
  echo -e "\n$i\n"
  cd $i;

  git checkout master
  git status
  masterver=$(grep '<version>' pom.xml |head -n1|awk -F '[<>]' '/version/{print $3}')
  if [ "$masterver" = "$version" ]; then
    echo -e "${GREEN}OK${NC}, master is in $masterver"
  else
    echo -e "${RED}Trouble${NC}, master is in $masterver"
  fi

  git checkout develop
  git status
  devver=$(grep '<version>' pom.xml |head -n1|awk -F '[<>]' '/version/{print $3}')
  if [ "$devver" = "${nextver}-SNAPSHOT" ]; then
    echo -e "${GREEN}OK${NC}, develop is in $devver"
  else
    echo -e "${RED}Trouble${NC}, develop is in $devver"
  fi

  git checkout release/$version
  git status
  relver=$(grep '<version>' pom.xml |head -n1|awk -F '[<>]' '/version/{print $3}')
  if [ "$relver" = "$version" ]; then
    echo -e "${GREEN}OK${NC}, release/$version is in $relver"
  else
    echo -e "${RED}Trouble${NC}, release/$version is in $relver"
  fi

  cd ..;
  read $input
done

