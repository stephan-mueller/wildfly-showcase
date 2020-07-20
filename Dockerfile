FROM openjdk:8-jre-alpine

RUN apk --no-cache add curl

ARG JAR_FILE=wildfly-showcase-wildfly.jar
COPY target/${JAR_FILE} /opt/application.jar

HEALTHCHECK --start-period=10s --timeout=60s --retries=10 --interval=5s CMD curl -f http://localhost:9990/health/ready || exit 1

ENV JAVA_OPTS="-Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 -Djboss.http.port=8080 -Djboss.management.http.port=9990"

EXPOSE 8080 9990
ENTRYPOINT exec java -jar $JAVA_OPTS /opt/application.jar