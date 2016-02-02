#!/usr/bin/env bash

REPO="bouquet-core bouquet-server bouquet-plugin-redshift bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql"
REPO_HADOOP="bouquet-plugin-apachedrill bouquet-plugin-spark"
PLUGINS="bouquet-plugin-redshift bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql"
PLUGINS_HADOOP="bouquet-plugin-apachedrill bouquet-plugin-spark"

echo "This script is going to clone the repositiories in `pwd`/../ and install the jars into your local m2"
echo "Use any argument to build hadoop plugins (Spark and Apache Drill)"

if [ ! -z "$1" ]
  then
    echo "Building Hadoop plugins"
    HADOOP=1
fi


cd ..

# folder containing the plugins jars
DRIVER_DIR=`pwd`/drivers
mkdir $DRIVER_DIR 2>/dev/null

# We use gitflow
for i in $REPO
do
	echo "Cloning" $i
	git clone https://github.com/openbouquet/$i &>/dev/null 2>/dev/null
	cd $i;
	git checkout develop 2>/dev/null
	git pull origin develop 2>/dev/null
	git flow init -d 2>/dev/null
	cd ..;
done

if [ ! -z $HADOOP ]
        then
		for i in $REPO_HADOOP 
		do
        		echo "Cloning" $i
		        git clone https://github.com/openbouquet/$i &>/dev/null 2>/dev/null
		        cd $i;
		        git checkout develop 2>/dev/null
		        git pull origin develop 2>/dev/null
		        git flow init -d 2>/dev/null
        		cd ..;
		done
fi

# Build core and server
cd bouquet-parent

if [ ! -z $HADOOP ]
 	then
		mvn clean install -DskipTests=true -Phadoop
else
		mvn clean install -DskipTests=true
fi

cd ..

# Build plugins
for i in $PLUGINS
do
        cd $i;
	mvn compile assembly:single && cp target/*-with-*.jar $DRIVER_DIR
        cd ..;
done
if [ ! -z $HADOOP ]
        then
                for i in $PLUGINS_HADOOP
		do
		        cd $i;
		        mvn compile assembly:single && cp target/*-with-*.jar $DRIVER_DIR
		        cd ..;
		done
fi


# Do the tests with the plugins
# will fail if no hadoop
if [ ! -z $HADOOP ]
    then
        cd bouquet-parent
        mvn test -Dkraken.plugin.dir=$DRIVER_DIR -Dkraken.dir.plugin=$DRIVER_DIR
else
        echo "Not running the tests since Hadoop plugins are necessary for that"
fi