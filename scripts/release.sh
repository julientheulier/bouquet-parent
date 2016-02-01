direc="squid-v4-core squid-v4-db-plugin-oracle squid-v4-db-plugins squid-v4-kraken squid-v4-parent squid-v4-tests"
if [ -z "$1" ]
  then
    echo "No version name"
    exit
fi
if [ -z "$2" ]
  then
    echo "No Driver folder"
    exit
fi

for i in $direc
do
	git clone git@git.squidsolutions.com:$i
	cd $i;
	git pull
	git checkout develop
	git flow init -d
	cd ..;
done

for i in $direc
do
        cd $i;
        git flow release start $1
        cd ..;
done

cd squid-v4-parent
mvn versions:set -DnewVersion=1.0.0-SNAPSHOT -DgenerateBackupPoms=false
mvn versions:set -DnewVersion=1.0.0-RELEASE -DgenerateBackupPoms=false
mvn clean install -DskipTests=true  && cd ../squid-v4-db-plugins &&  mvn compile assembly:single && cp squid-v4-db-plugin-*/target/*-with-*.jar $2 && cd ../squid-v4-db-plugin-oracle && mvn compile assembly:single && cp target/*-with-*.jar $2  && cd ../squid-v4-parent && mvn test -Dkraken.plugin.dir=$2 -Dkraken.dir.plugin=$2
mvn versions:set -DnewVersion=1.0.0-SNAPSHOT -DgenerateBackupPoms=false
cd ..

for i in $direc
do
        cd $i;
        git flow release finish -m"$1" $1
	    git push --tags
        cd ..;
done
