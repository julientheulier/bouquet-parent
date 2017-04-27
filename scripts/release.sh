#!/bin/bash  
direc="bouquet-core bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql bouquet-plugin-redshift bouquet-plugin-teradata bouquet-server bouquet-parent";
dirprivate="bouquet-plugin-oracle squid-v4-tests obs-tests";
alldirs="$direc $dirprivate";

version="$1"
nextver="$2"

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


exists=`git show-ref remotes/origin/release/$version`
if [ -n "$exists" ]; then
  echo "This branch $version already exists!"
  exit 1
fi


current_time=$(date "+%Y.%m.%d-%H")
workdir=$workdir/release.$current_time;

echo "workdir : $workdir";
mkdir $workdir;
cd $workdir;

# repositories setup
for i in $direc
do
	git clone git@github.com:openbouquet/$i -b develop
	cd $i;
	git pull
	cd ..;
done
for i in $dirprivate
do
	git clone git@admin.squidsolutions.com:$i -b develop
	cd $i;
	git pull
	cd ..;
done

#
# start releases
#
for i in $alldirs
do
	echo starting release $version for $i
        cd $i;
        git checkout -b release/$version
        cd ..;
done

#
# set release branches version to $version
#
cd bouquet-parent
mvn versions:set -DnewVersion=$version -DgenerateBackupPoms=false
cd ..;
for i in $alldirs
do
		echo committing $i as $version
        cd $i;
        git commit -am"set master branch pom version to $version"
        cd ..;
done

#
# finish gitflow releases
#
for i in $alldirs
do
		
        cd $i;
        echo finishing $i
        git checkout master
        git merge --no-edit release/$version
        git tag -am"$version" $version
        # keep release branches instead of doing : git branch -d release/$version
        git checkout develop
        # back merge to develop
        git merge --no-edit master
        cd ..;
done

#
# set develop branches version to to next version $nextver-SNAPSHOT
#
cd bouquet-parent
mvn versions:set -DnewVersion=$nextver-SNAPSHOT -DgenerateBackupPoms=false
cd ..;
for i in $alldirs
do
        cd $i;
        echo setting develop branch $i to $nextver-SNAPSHOT
        git commit -am"set develop branch pom version to $nextver-SNAPSHOT"
        cd ..;
done

cd ..

