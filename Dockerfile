from maven: latest as build
copy ./pom.xml ./pom.xml
copy ./src ./src
run mvn package
from openjdk:8-jdk
workdir /app
copy --from=build target/sample-*.jar ./sample.jar
cmd ["java","-jar","./sample.jar"]
