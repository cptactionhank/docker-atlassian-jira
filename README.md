# Atlassian JIRA in a Docker container

> Version 6.4.11

[![Build Status](https://img.shields.io/circleci/project/cptactionhank/docker-atlassian-jira/6.4.11.svg)](https://circleci.com/gh/cptactionhank/docker-atlassian-jira) [![Open Issues](https://img.shields.io/github/issues/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Stars on GitHub](https://img.shields.io/github/stars/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Forks on GitHub](https://img.shields.io/github/forks/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Stars on Docker Hub](https://img.shields.io/docker/stars/cptactionhank/atlassian-jira.svg)](https://registry.hub.docker.com/u/cptactionhank/atlassian-jira) [![Pulls on Docker Hub](https://img.shields.io/docker/pulls/cptactionhank/atlassian-jira.svg)](https://registry.hub.docker.com/u/cptactionhank/atlassian-jira)

A containerized installation of Atlassian JIRA setup with a goal of keeping the installation as default as possible, but with a few Docker related twists.

Want to help out, check out the contribution section.

## Important changes

Here you can read about significant changes to the repository/Docker image.

### Since 6.4.6

The Java Runtime Environment has been updated to use OpenJDK 8 and there has been some changes to the installation and home directory to better follow the [Filesystem Hierarchy Standard](http://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.txt). Thanks @frederickding for noticing and suggesting some changes. The environment variable values has been changed accordingly.

The installation directory `/opt/atlassian/jira` is not mounted as a volume as standard anymore. Should you need to persist changes in this directory run the container with the additional argument `--volume /opt/atlassian/jira`.

## Patches

### 20. september 2015

Now bundles the MySQL Connector/J driver which is the official JDBC driver for MySQL. This means that you can now use MySQL as a database backend since it was not bundled by default with the Atlassian JIRA distribution. It looks like Oracle 11g and Microsoft SQL Server drivers are bundled as well as drivers for HyperSQL and PostgreSQL.

## I'm in the fast lane! Get me started

To quickly get started with running a JIRA instance, first run the following command:
```bash
docker run --detach --publish 8080:8080 cptactionhank/atlassian-jira:latest
```

Then use your browser to nagivate to `http://[dockerhost]:8080` and finish the configuration.

## The slower road to get started

> The following documentation is outdated and might be obsolete, this is kept until a wiki or webpage is setup with better documentation.

An assumption is made that the docker version is at least 1.3.0 for the additional methods `docker exec` and `docker create`.

This is how to create the container for running an Atlassian JIRA instance and before you run the command as is take note of the `[your settings]` which should be left out or filled to suit your needs.

```bash
docker create [your settings] cptactionhank/atlassian-jira:latest
```

Below is some documentation for additional configuration of the JIRA application, keep in mind this is the only tested configuration to suit own needs.

### Additional JIRA settings

Use the `CATALINA_OPTS` environment variable for changing advanced settings eg. changing memory consumption or extending plugin loading timeout. All possible configuration settings can be found at the Atlassian JIRA [documentation](https://confluence.atlassian.com/display/JIRA/Recognized+System+Properties+for+JIRA).

Use with Docker add `--env 'CATALINA_OPTS=[settings]'` as part of your container configuration flags.

#### JVM memory configuration

To change the default memory configuration to your machine with extended memory usage settings add the following string to your `CATALINA_OPTS` environment variable. This will setup the JVM to be running with 128MB as minimum and 1GB as maximum allocatable memory.

```
-Xms128m -Xmx1024m
```

More information about [`-Xms`](http://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html#wp999528) and [`-Xmx`](http://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html#wp999527) visit [here](http://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html).

#### Plugin loading timeout

To change the plugin loading timeout to _5 minutes_ the following string should be added to the `CATALINA_OPTS` environment variable.

```
-Datlassian.plugins.enable.wait=300
```

#### Apache Portable Runtime (APR) based Native library for Tomcat

This is enabled by default.

### Running as a different user

Here will be information on how to run as a different user

```
--user "docker-user:docker-group"
```

make sure the home directory `/var/atlassian/jira` is set up with full read, write, and execute permissions on the directory.

If not mounting the home directory volume yourself you can change the folder permissions by

```bash
$ docker exec [container] chown docker-user:docker-group /var/atlassian/jira
```

Please note that the exec will be executed as the supplied user in the `docker create` command, ie. `docker-user:docker-group`. You can circumvent this by

```bash
$ docker run -ti --rm --user root:root --volumes-from [container] java:7 chown docker-user:docker-group /var/atlassian/jira
```

### Customizations

Example mounting files to change log4j logging output:

```
--volume "[hostpath]/log4j.properties:/opt/atlassian/jira/atlassian-jira/WEB-INF/classes/log4j.properties"
```

This should also be modifiable to suit your needs.

### Reverse Proxy Support

You need to change the `/opt/atlassian/jira/conf/server.xml` file inside the container to include a couple of Connector [attributes](http://tomcat.apache.org/tomcat-8.0-doc/config/http.html#Proxy_Support).

Gaining access to the `server.xml` file on a running container use the following docker command edited to suit your setup

```bash
$ docker run -ti --rm --volumes-from <container> ubuntu:latest vi /opt/atlassian/jira/conf/server.xml
```

Within this container the file can be accessed and edited to match your configuration (remember to restart the JIRA container after).

#### HTTP

For a reverse proxy server listening on port 80 (HTTP) for inbound connections add and edit the following connector attributes to suit your setup.

```xml
<connector ...
   proxyName="example.com"
   proxyPort="80"
   scheme="http"
   ...
></connector>
```

#### HTTPS

For a reverse proxy server listening on port 443 (HTTPS) for inbound connections add and edit the following connector attributes to suit your setup.

```xml
<connector ...
   proxyName="example.com"
   proxyPort="443"
   scheme="https"
   ...
></connector>
```

## Contributions

This has been made with the best intentions and current knowledge and thus it shouldn't be expected to be flawless. However you can support this repository with best-practices and other additions. Cirlce-CI has been setup to build the Dockerfile and run acceptance tests on the Atlassian JIRA image to ensure it is working.

Circle-CI has been setup to automatically deploy new version branches when successfully building a new version of Atlassian JIRA in the `master` branch and serves as the base. Futhermore an `eap` branch has been setup to automatically build and commit updates to ensure the `eap` branch contains the latest version of Atlassian JIRA Early Access Preview.

Out of date documentation, lack of tests, etc. you can help out by either creating an issue and open a discussion or sending a pull request with modifications to the appropiate branch.

Acceptance tests are performed by Circle-CI with Ruby using the RSpec, Capybara, and phantomjs frameworks.
