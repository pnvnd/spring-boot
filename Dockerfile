FROM openjdk:8 AS base

# Copy repository to base image and publish your application
WORKDIR /app
COPY . .

# Download New Relic Agent, Extract New Relic Agent, then delete .zip file
RUN curl -O https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && jar xvf newrelic-java.zip

# Compile JAR file
RUN ./mvnw install

# Copy published application and New Relic Agent from base image to final image to reduce size
FROM openjdk:8-jre-alpine AS final
WORKDIR /app
COPY --from=base /app/target ./target
COPY --from=base /app/newrelic ./newrelic
# COPY --from=base /app/script-runner.sh ./

# Set environment variables for New Relic Agent (Optional)
# ENV NEW_RELIC_LICENSE_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNRAL
# ENV NEW_RELIC_APP_NAME=spring-boot.docker

EXPOSE 8080

ENTRYPOINT ["java", "-javaagent:newrelic/newrelic.jar", "-jar", "target/spring-boot-0.0.1-SNAPSHOT.jar"]
# ENTRYPOINT ["/app/script-runner.sh"]