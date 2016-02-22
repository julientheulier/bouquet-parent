#!/bin/bash  
direc="bouquet-core bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql bouquet-plugin-redshift bouquet-plugin-spark bouquet-plugin-apachedrill bouquet-server bouquet-parent";
dirprivate="bouquet-plugin-oracle squid-v4-tests";
alldirs="$direc $dirprivate";


if [ -z "$1" ]
  then
  	echo "No version name"
    echo usage: $0 version next-version workdir
    exit
fi
if [ -z "$2" ]
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

echo "workdir : $workdir";
cd $workdir;

# repositories setup
for i in $direc
do
	git clone git@github.com:openbouquet/$i
	cd $i;
	git pull
	git checkout develop
	git flow init -d
	cd ..;
done
for i in $dirprivate
do
	git clone git@admin.squidsolutions.com:$i
	cd $i;
	git pull
	git checkout develop
	git flow init -d
	cd ..;
done

#
# start gitflow releases
#
for i in $alldirs
do
        cd $i;
        git flow release start $1
        cd ..;
done

#
# set master branches version to $1
#
cd bouquet-parent
mvn versions:set -DnewVersion=$1 -DgenerateBackupPoms=false
cd ..;
for i in $alldirs
do
        cd $i;
        git commit -am"set master branch pom version to $1"
        cd ..;
done

#
# finish gitflow releases
#
for i in $alldirs
do
        cd $i;
        #git flow release finish -m"$1" $1
        git checkout master
        git merge --no-edit release/$1
        git tag -am"$1" $1
        git branch -d release/$1
        git checkout develop
        cd ..;
done

#
# set develop branches version to to next version $2-SNAPSHOT
#
cd bouquet-parent
mvn versions:set -DnewVersion=$2-SNAPSHOT -DgenerateBackupPoms=false
cd ..;
for i in $alldirs
do
        cd $i;
        git commit -am"set develop branch pom version to $2-SNAPSHOT"
        cd ..;
done

cd ..

