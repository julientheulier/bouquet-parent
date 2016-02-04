
bouquet setup
-------------

# bouquet-server

third-party software required :
* java 1.7+
* mongodb
* redis

clone the bouquet-parent repository
from your bouquet-parent directory execute the build script which will clone all required repositories and launch the maven install.
note : the database connector jars will be isntalled in a "drivers" directory.
```
./scripts/build.sh
```

from your bouquet-server directory, setup bouquet config files
```
cd bouquet-server/config
cp bouquet_sample.xml bouquet.xml
cp redis_sample.json redis.json
```
edit bouquet.xml to match your mongo db connection settings
edit redis.json to match your redis connection settings

launch bouquet server (from maven)
```
mvn tomcat7:run
```

check server logs at
bouquet-server/target/tomcat/logs/kraken.log

check that bouquet api is responding by opening the 'status' endpoint (all you db connectors should be listed)
http://localhost:9000/dev/v4.2/rs/status

Now let's create a new "default" Customer along with a super-user account (admin/admin123)

```
curl --form "customerName=default;login=admin;password=admin123" localhost:9000/dev/v4.2/admin/create-customer
```

# bouquet-auth