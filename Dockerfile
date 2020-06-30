FROM jboss/wildfly:20.0.0.Final

RUN $JBOSS_HOME/bin/add-user.sh admin Admin#70365 --silent

ARG WAR_FILE

COPY target/$WAR_FILE $JBOSS_HOME/standalone/deployments/$WAR_FILE

HEALTHCHECK --start-period=10s --timeout=60s --retries=10 --interval=5s CMD curl -f http://localhost:9990/health/ready || exit 1

ENV JAVA_OPTS="-Djboss.server.default.config=standalone-microprofile.xml -Djboss.http.port=8080 -Djboss.management.http.port=9990"

EXPOSE 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]