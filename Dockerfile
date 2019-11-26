FROM jboss/wildfly:19.0.0.Final

RUN $JBOSS_HOME/bin/add-user.sh admin Admin#70365 --silent

ARG WAR_FILE=wildfly-showcase.war

COPY target/$WAR_FILE $JBOSS_HOME/standalone/deployments/$WAR_FILE

ENV JAVA_OPTS="-Djboss.server.default.config=standalone-microprofile.xml -Djboss.http.port=8080 -Djboss.management.http.port=9990"

EXPOSE 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]