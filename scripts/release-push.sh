#!/bin/bash  
direc="bouquet-core bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql bouquet-plugin-redshift bouquet-plugin-teradata bouquet-server bouquet-parent";
dirprivate="bouquet-plugin-oracle squid-v4-tests";
alldirs="$direc $dirprivate";

if [ -z "$1" ]
  then
  	echo "No version name"
    echo usage: $0 version workdir
    exit
fi

workdir="$2";
if [ -z $workdir ]
  then
  	echo "Workdir must be specified"
    echo usage: $0 version workdir
    exit
fi

echo "workdir : $workdir";
cd $workdir;

#
# push
#
for i in $alldirs
do
        cd $i;
        git push --tags
        git push origin master
        git push --set-upstream  origin release/$1
        git push origin develop
        cd ..;
done
