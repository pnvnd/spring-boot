#!/bin/sh

echo "----------------"
java -javaagent:newrelic/newrelic.jar -jar target/spring-boot-0.0.1-SNAPSHOT.jar
echo "----------------"

echo "End executiing"