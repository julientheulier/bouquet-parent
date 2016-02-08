
bouquet setup
-------------

# bouquet-server

third-party software required :
* java 1.7+
* mongodb
* redis

clone the bouquet-parent repository  
from your bouquet-parent directory execute the build script which will clone all required repositories and launch the maven install.  
note : the database connector jars will be installed in a "drivers" directory.  
```
cd bouquet-parent
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
cd ..
mvn tomcat7:run
```

check server logs at  
bouquet-server/target/tomcat/logs/kraken.log  

check that bouquet api is responding by opening the 'status' endpoint (all you db connectors should be listed)  
<http://localhost:9000/dev/v4.2/rs/status>

Now let's create a new "default" Customer along with a super-user account (admin/admin123)  
```
curl --form "customerName=default;login=admin;password=admin123" localhost:9000/dev/v4.2/admin/create-customer
```

# bouquet-auth

In order to handle users authentication, the auth webapp has to be running.  

clone the bouquet-auth repository  
```
git clone https://github.com/openbouquet/bouquet-auth.git
```

launch bouquet auth webapp (from maven)
```
cd bouquet-auth
mvn tomcat7:run
```

try by accessing the 'users' endpoint which requires a valid auth token to display registered users list  
<http://localhost:8080/admin/auth/oauth?response_type=token&redirect_uri=http://localhost:9000/dev/v4.2/rs/users&client_id=admin_console>

Now you're ready to work with Bouquet.




