# Atlassian JIRA in a Docker container

> Version 7.0.0

[![Build Status](https://img.shields.io/circleci/project/cptactionhank/docker-atlassian-jira/7.0.0.svg)](https://circleci.com/gh/cptactionhank/docker-atlassian-jira) [![Open Issues](https://img.shields.io/github/issues/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Stars on GitHub](https://img.shields.io/github/stars/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Forks on GitHub](https://img.shields.io/github/forks/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Stars on Docker Hub](https://img.shields.io/docker/stars/cptactionhank/atlassian-jira.svg)](https://registry.hub.docker.com/u/cptactionhank/atlassian-jira) [![Pulls on Docker Hub](https://img.shields.io/docker/pulls/cptactionhank/atlassian-jira.svg)](https://registry.hub.docker.com/u/cptactionhank/atlassian-jira)

A containerized installation of Atlassian JIRA setup with a goal of keeping the installation as default as possible, but with a few Docker related twists.

Want to help out, check out the contribution section.

## I'm in the fast lane! Get me started

To quickly get started with running a JIRA instance, first run the following command:
```bash
docker run --detach --publish 8080:8080 cptactionhank/atlassian-jira:latest
```

Then use your browser to navigate to `http://[dockerhost]:8080` and finish the configuration.

## The slower road to get started

For a more in-depth documentation on how to get started please visit the website made for this purpose.

[https://cptactionhank.github.io/docker-atlassian-jira](https://cptactionhank.github.io/docker-atlassian-jira)

## Important changes

Here you can read about significant changes to the repository/Docker image.

### Since 7.0.0

Big changes to JIRA means "big changes" to the Docker image, which from now on will feature Atlassian JIRA Core. The additional packages will be coming soon after it has been decided on how to approach packaging JIRA Software and JIRA ServiceDesk.

### Since 6.4.6

The Java Runtime Environment has been updated to use OpenJDK 8 and there has been some changes to the installation and home directory to better follow the [Filesystem Hierarchy Standard](http://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.txt). Thanks @frederickding for noticing and suggesting some changes. The environment variable values has been changed accordingly.

The installation directory `/opt/atlassian/jira` is not mounted as a volume as standard anymore. Should you need to persist changes in this directory run the container with the additional argument `--volume /opt/atlassian/jira`.

## Patches

Here you can read about significant changes to the repository/Docker image.

### 20. September 2015

Now bundles the MySQL Connector/J driver which is the official JDBC driver for MySQL. This means that you can now use MySQL as a database back-end since it was not bundled by default with the Atlassian JIRA distribution. It looks like Oracle 11g and Microsoft SQL Server drivers are bundled as well as drivers for HyperSQL and PostgreSQL.

## Contributions

This has been made with the best intentions and current knowledge and thus it shouldn't be expected to be flawless. However you can support this repository with best-practices and other additions. Circle-CI has been setup to build the Dockerfile and run acceptance tests on the Atlassian JIRA image to ensure it is working.

Circle-CI has been setup to automatically deploy new version branches when successfully building a new version of Atlassian JIRA in the `master` branch and serves as the base. Furthermore an `eap` branch has been setup to automatically build and commit updates to ensure the `eap` branch contains the latest version of Atlassian JIRA Early Access Preview.

Out of date documentation, lack of tests, etc. you can help out by either creating an issue and open a discussion or sending a pull request with modifications to the appropriate branch.

Acceptance tests are performed by Circle-CI with Ruby using the RSpec, Capybara, and PhantomJS frameworks.
