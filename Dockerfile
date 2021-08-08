FROM gcr.io/cloud-builders/mvn AS build

ARG VER
ENV VER ${VER}

COPY pom.xml /app/pom.xml
COPY src /app/src
RUN mvn -Drevision=${VER} clean package -f /app/

FROM openjdk:11.0.3-jdk-stretch

ARG VER
ENV VER ${VER}

RUN apt-get update
RUN apt-get install -y --no-install-recommends telnet curl
COPY --from=build ./app/target/springapp-*.jar /
CMD ["sh", "-c", "java -jar springapp-0.0.1-SNAPSHOT.jar"]
