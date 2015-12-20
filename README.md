# Atlassian JIRA in a Docker container

> Version 7.0.5

[![Build Status](https://img.shields.io/circleci/project/cptactionhank/docker-atlassian-jira/7.0.5.svg)](https://circleci.com/gh/cptactionhank/docker-atlassian-jira) [![Open Issues](https://img.shields.io/github/issues/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Stars on GitHub](https://img.shields.io/github/stars/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Forks on GitHub](https://img.shields.io/github/forks/cptactionhank/docker-atlassian-jira.svg)](https://github.com/cptactionhank/docker-atlassian-jira) [![Stars on Docker Hub](https://img.shields.io/docker/stars/cptactionhank/atlassian-jira.svg)](https://registry.hub.docker.com/u/cptactionhank/atlassian-jira) [![Pulls on Docker Hub](https://img.shields.io/docker/pulls/cptactionhank/atlassian-jira.svg)](https://registry.hub.docker.com/u/cptactionhank/atlassian-jira)

A containerized installation of Atlassian JIRA setup with a goal of keeping the installation as default as possible, but with a few Docker related twists.

Want to help out, check out the contribution section.

## I'm in the fast lane! Get me started

To quickly get started with running a JIRA instance, first run the following command:
```bash
docker run --detach --publish 8080:8080 cptactionhank/atlassian-jira:7.0.5
```

Then use your browser to navigate to `http://[dockerhost]:8080` and finish the configuration.

## The slower road to get started

For a more in-depth documentation on how to get started please visit the website made for this purpose. [cptactionhank.github.io/docker-atlassian-jira](https://cptactionhank.github.io/docker-atlassian-jira)

## Contributions

This has been made with the best intentions and current knowledge and thus it shouldn't be expected to be flawless. However you can support this repository with best-practices and other additions. Circle-CI has been setup to build the Dockerfile and run acceptance tests on the Atlassian JIRA image to ensure it is working.

Circle-CI has been setup to automatically deploy new version branches when successfully building a new version of Atlassian JIRA in the `master` branch and serves as the base. Furthermore an `eap` branch has been setup to automatically build and commit updates to ensure the `eap` branch contains the latest version of Atlassian JIRA Early Access Preview.

Out of date documentation, lack of tests, etc. you can help out by either creating an issue and open a discussion or sending a pull request with modifications to the appropriate branch.

Acceptance tests are performed by Circle-CI with Ruby using the RSpec, Capybara, and PhantomJS frameworks.
