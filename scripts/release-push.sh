#!/bin/bash  
direc="bouquet-core bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql bouquet-plugin-redshift bouquet-plugin-spark bouquet-plugin-apachedrill bouquet-server bouquet-parent";
dirprivate="bouquet-plugin-oracle squid-v4-tests";
alldirs="$direc $dirprivate";

workdir="$1";
if [ -z $workdir ]
  then
  	echo "Workdir must be specified"
    echo usage: $0 workdir
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
        git push origin develop
        cd ..;
done
