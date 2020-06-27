# Wildfly Showcase

[![GitHub last commit](https://img.shields.io/github/last-commit/stephan-mueller/wildfly-showcase)](https://github.com/stephan-mueller/wildfly-showcase/commits) 
[![GitHub](https://img.shields.io/github/license/stephan-mueller/wildfly-showcase)](https://github.com/stephan-mueller/wildfly-showcase/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/stephan-mueller/wildfly-showcase.svg?style=shield)](https://app.circleci.com/pipelines/github/stephan-mueller/wildlfy-showcase)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=stephan-mueller_wildfly-showcase&metric=alert_status)](https://sonarcloud.io/dashboard?id=stephan-mueller_wildfly-showcase)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=stephan-mueller_wildfly-showcase&metric=coverage)](https://sonarcloud.io/dashboard?id=stephan-mueller_wildfly-showcase)

This is a showcase for the [Wildfly](https://wildfly.org) application server. It contains a hello world application, which demonstrates several features of Wildfly and Eclipse Microprofile

Software requirements to run the samples are `maven`, `openjdk-1.8` (or any other 1.8 JDK) and `docker`. When running the Maven lifecycle it will create the war package. The war will be copied into a Docker image using Spotify's `dockerfile-maven-plugin` during the package phase. 

## How to run

Before running the application it needs to be compiled and packaged using Maven. It creates the required war,
jar and Docker image and can be run via `docker`:

```shell script
$ mvn clean package
$ docker run --rm -p 8080:8080 -p 9990:9990 wildfly-showcase
```

Wait for a message log similar to this:

> 19:19:21,704 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: WildFly Full 19.0.0.Final (WildFly Core 11.0.0.Final) started in 7429ms - Started 308 of 470 services (240 services are lazy, passive or on-demand)

If everything worked you can access the OpenAPI UI via http://localhost:8080/swagger-ui.

## Resolving issues

Sometimes it may happen that the containers did not stop as expected when trying to stop the pipeline early. This may
result in running containers although they should have been stopped and removed. To detect them you need to check
Docker:

```shell script
$ docker ps -a | grep wildfly-showcase
```

If there are containers remaining although the application has been stopped you can remove them:

````shell script
$ docker rm <ids of the containers>
````