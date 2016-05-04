# Bouquet Parent [![Build Status](https://travis-ci.org/openbouquet/bouquet-parent.svg?branch=master)](https://travis-ci.org/openbouquet/bouquet-parent)

Bouquet Parent contains the parent maven project.

## About Bouquet

![Bouquet logo](https://p3.zdassets.com/hc/settings_assets/734011/200131331/Ctg9MxzHvBc0pLSmLyIebg-bouquet-logo.png)

[Bouquet](http://openbouquet.io) is an open-source analytics toolbox to explore, share, and connect your data to applications and visualizations.

## Table of contents

* [Overview](#overview)
* [Bugs and feature requests](#bugs-and-feature-requests)
* [Install and setup](#install-and-setup)
* [Contributing](#contributing)

## Overview

![Bouquet components](http://i.imgur.com/tZ32dNW.png)

## Bugs and feature requests

Have a bug or a feature request? Please first read the issue search for existing and closed issues. If your problem or idea is not addressed yet, please open a new issue.

## Install and setup

### Bouquet server installation

Requirements:

- Java 1.7+
- MongoDB
- Redis
- tomcat7
- maven

1. Clone the [Bouquet parent](https://github.com/openbouquet/bouquet-parent) repository
2. Execute the build script to get dependencies and launch the maven install

> Note : the database connectors `jars` will be installed in the "drivers" directory.

```
cd bouquet-parent
./scripts/build.sh
```

3. From the Bouquet server directory, edit the Bouquet Server configuration file:

```
cd bouquet-server/config
cp bouquet-sample.json bouquet.json
```

Open `bouquet.json` file and edit the mongo db connection settings.

4. Launch bouquet server (from maven).
```
cd ..
mvn tomcat7:run
```

5. Check out the server logs in `bouquet-server/target/tomcat/logs/kraken.log` file

6. Check that the Bouquet API is responding by querying the `status` endpoint (All the database connectors are listed by this endpoint) `http://localhost:9000/dev/v4.2/rs/status`

7. Create a new "default" customer with a super-user account

```
curl --form "customerName=default;login=admin;password=<your-password>" localhost:9000/dev/v4.2/admin/create-customer
```

### Bouquet auth installation

In order to handle user authentication, the auth webapp must be be running.

1. Clone the [Bouquet auth](https://github.com/openbouquet/bouquet-auth) repository

2. Launch Bouquet auth webapp (from maven)

```
cd bouquet-auth
mvn tomcat7:run
```

4. Check that the Bouquet auth is responding by querying the `users` endpoint which requires a valid auth token to display the registered user list.

`http://localhost:8080/admin/auth/oauth?response_type=token&redirect_uri=http://localhost:9000/dev/v4.2/rs/users&client_id=admin_console`

Now you're ready to work with Bouquet.

Installation instructions, getting started guides, and in-depth API documentation.

https://bouquet.zendesk.com/hc/en-us

## Contributing

The Bouquet development team is always excited to merge new code and fixes into Bouquet projects. Please checkout our [contribution guidelines](CONTRIBUTING.md) before starting.

## License

You can find the project license [here](LICENSE.txt).

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

## Contributing

The Bouquet development team is always excited to merge new code and fixes into Bouquet projects. Please checkout our [contribution guidelines](CONTRIBUTING.md) before starting.

