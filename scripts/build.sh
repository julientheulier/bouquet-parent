#!/usr/bin/env bash

REPO="bouquet-core bouquet-server bouquet-plugin-redshift bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql"
REPO_HADOOP="bouquet-plugin-apachedrill bouquet-plugin-spark"
PLUGINS="bouquet-plugin-redshift bouquet-plugin-postgresql bouquet-plugin-greenplum bouquet-plugin-mysql"
PLUGINS_HADOOP="bouquet-plugin-apachedrill bouquet-plugin-spark"

echo "This script is going to clone the repositories in `pwd`/../ and install the jars into your local m2"
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

# Clone the repositories
for i in $REPO
do
	echo "Cloning" $i
	git clone https://github.com/openbouquet/$i &>/dev/null 2>/dev/null
done

if [ ! -z $HADOOP ]
        then
		for i in $REPO_HADOOP 
		do
        		echo "Cloning" $i
		        git clone https://github.com/openbouquet/$i &>/dev/null 2>/dev/null
		done
fi

# HikariCP
echo "Cloning HikariCP"
git clone https://github.com/openbouquet/HikariCP &>/dev/null 2>/dev/null
cd HikariCP
mvn clean install -DskipTests=true -Dmaven.test.skip=true
cd ..;

# Build core and server
cd bouquet-parent

if [ ! -z $HADOOP ]
 	then
		mvn clean install -DskipTests=true -Phadoop
else
		mvn clean install -DskipTests=true -Plocal
fi

cd ..

# Install Redshift JDBC driver
echo "Installing Redshift JDBC driver"
./bouquet-plugin-redshift/lib/maven-redshift-amazon-install.sh

# Build plugins
for i in $PLUGINS
do
        cd $i;
		mvn compile assembly:single -Plocal && cp target/*-with-*.jar $DRIVER_DIR
        cd ..;
done
if [ ! -z $HADOOP ]
        then
                for i in $PLUGINS_HADOOP
		do
		        cd $i;
		        mvn compile assembly:single -Plocal && cp target/*-with-*.jar $DRIVER_DIR
		        cd ..;
		done
fi


# Do the tests with the plugins
# will fail if no hadoop
if [ ! -z $HADOOP ]
    then
        cd bouquet-parent
        mvn test -Pallplugins -Ptest -Dkraken.plugin.dir=$DRIVER_DIR -Dkraken.dir.plugin=$DRIVER_DIR
else
        echo "Not running the tests since Hadoop plugins are necessary for that"
fi
