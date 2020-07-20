# Wildfly Showcase

[![GitHub last commit](https://img.shields.io/github/last-commit/stephan-mueller/wildfly-showcase)](https://github.com/stephan-mueller/wildfly-showcase/commits) 
[![GitHub](https://img.shields.io/github/license/stephan-mueller/wildfly-showcase)](https://github.com/stephan-mueller/wildfly-showcase/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/stephan-mueller/wildfly-showcase.svg?style=shield)](https://app.circleci.com/pipelines/github/stephan-mueller/wildfly-showcase)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=stephan-mueller_wildfly-showcase&metric=alert_status)](https://sonarcloud.io/dashboard?id=stephan-mueller_wildfly-showcase)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=stephan-mueller_wildfly-showcase&metric=coverage)](https://sonarcloud.io/dashboard?id=stephan-mueller_wildfly-showcase)

This is a showcase for the [Wildfly](https://wildfly.org) application server. It contains a hello world application, 
which demonstrates several features of Wildfly and Eclipse Microprofile.

Software requirements to run the samples are `maven`, `openjdk-1.8` (or any other 1.8 JDK) and `docker`. 
When running the Maven lifecycle it will create the war package and use the `wildfly-jar-maven-plugin` to create a bootable jar (fat JAR) 
which contains the application and the Wildfly application server. 
The fat JAR will be copied into a Docker image using Spotify's dockerfile-maven-plugin during the package phase.

**Notable Features:**
* Dockerfiles for bootable JAR & Server
* Integration of MP Health, MP Metrics and MP OpenAPI
* Testcontainer-Tests with Rest-Assured, Cucumber and Postman/newman
* [CircleCI](https://circleci.com) Integration
* [Sonarcloud](https://sonarcloud.io) Integration


## How to run

Before running the application it needs to be compiled and packaged using `Maven. It creates the bootable JAR and Docker image and can be 
run via `docker`:

```shell script
$ mvn clean package
$ docker run --rm -p 8080:8080 -p 9990:9990 wildfly-showcase
```

For the _normal_ Wildfly Server a multi-stage Docker image is provided and can be created and run via `docker`:    
```shell script
$ docker build -f Dockerfile.server -t wildfly-server-showcase .
$ docker run --rm -p 8080:8080 -p 9990:9990 wildfly-server-showcase
```

Wait for a message log similar to this:

> 13:41:24,806 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: WildFly Full 20.0.1.Final (WildFly Core 12.0.3.Final) started in 4073ms - Started 271 of 341 services (129 services are lazy, passive or on-demand)

If everything worked you can access the OpenAPI UI via http://localhost:8080/swagger-ui.

### Resolving issues

Sometimes it may happen that the containers did not stop as expected when trying to stop the pipeline early. This may
result in running containers although they should have been stopped and removed. To detect them you need to check
Docker:

```shell script
$ docker ps -a | grep wildfly-showcase
```

If there are containers remaining although the application has been stopped you can remove them:

```shell script
$ docker rm <ids of the containers>
```


## Features

### Application 

The application is a very simple "Hello World" greeting service. It supports GET requests for generating a greeting message, and a PUT 
request for changing the greeting itself. The response is encoded using JSON.

**Try the application**
```shell script
curl -X GET http://localhost:8080/greet
{"message":"Hello World!"}

curl -X GET http://localhost:8080/greet/Stephan
{"message":"Hello Stephan!"}

curl -X PUT -H "Content-Type: application/json" -d '{"greeting" : "Hola"}' http://localhost:8080/greet/greeting

curl -X GET http://localhost:8080/greet/greeting
{"greeting":"Hola"}

curl -X GET http://localhost:8080/greet/Max
{"message":"Hola Max!"}
```

### Health, Metrics and OpenAPI

The application server provides built-in support for health, metrics and openapi endpoints.

**Health liveness and readiness**
```shell script
curl -s -X GET http://localhost:9990/health

curl -s -X GET http://localhost:9990/health/live

curl -s -X GET http://localhost:9990/health/ready
```

**Metrics in Prometheus / JSON Format**
```shell script
curl -s -X GET http://localhost:9990/metrics

curl -H 'Accept: application/json' -X GET http://localhost:9990/metrics
```

**OpenAPI in YAML / JSON Format**
```shell script
curl -s -X GET http://localhost:8080/openapi

curl -H 'Accept: application/json' -X GET http://localhost:8080/openapi
```

### Bootable JAR (wildfly-jar-maven-plugin)

The [Wildfly jar maven plugin](https://github.com/wildfly-extras/wildfly-jar-maven-plugin/releases/download/2.0.0.Alpha5/index.html) is 
aimed to build a bootable JAR for WildFly (starting version 20.0.0.Final). A WildFly bootable JAR contains both the server and your 
packaged application (a JAR, a EAR or a WAR). Once the application has been built and packaged as a bootable JAR, you can start the 
application using the following command:

```shell script
$ java -jar target/wildfly-showcase-wildfly.jar
```

When building a bootable JAR you have to select the set of WildFly server 
[Galleon layers](https://docs.wildfly.org/20/Admin_Guide.html#defined-galleon-layers) which has to be present in the bootable JAR. 
Selecting a subset of server features has an impact on the server xml configuration and the set of installed JBoss modules. 
By selecting the subset required by your application you will reduce the jar size, server configuration content and memory footprint.

**Please note:** Wildfly provides numerous basic, aggregration and decorator layers. Depending on the APIs you are using, you have to 
select a set of layers. E.g. if you expose the API documentation of your application by using Microprofile OpenAPI, you have to add the 
`microprofile-openapi` layer. If you miss adding a required layer for a specific API the corresponding implementation will not be added to 
the bootable JAR and the expected functionality will not be available during runtime.

**Maven POM file**
```xml
<plugin>
    <groupId>org.wildfly.plugins</groupId>
    <artifactId>wildfly-jar-maven-plugin</artifactId>
    <version>2.0.0.Alpha5</version>
    <configuration>
        <feature-pack-location>wildfly@maven(org.jboss.universe:community-universe)#20.0.1.Final</feature-pack-location>
        <layers>
            <layer>jaxrs-server</layer>         <!-- provides JAX-RS, CDI, Bean-Validation and JPA layers        -->
            <layer>management</layer>           <!-- provides support for remote access to management interfaces -->
            <layer>observability</layer>        <!-- provides MP Config, MP Health and MP Metrics layer          -->
            <layer>microprofile-openapi</layer> <!-- provides MP OpenAPI layer                                   -->
        </layers>
        <excluded-layers>
            <layer>deployment-scanner</layer>   <!-- excludes support for deployment directory scanning          -->
        </excluded-layers>
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>package</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```