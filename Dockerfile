FROM openjdk:17-jdk-slim

WORKDIR /app

ARG JAR_FILE=build/libs/*main.jar

COPY ${JAR_FILE} app.jar

EXPOSE 8081

ENTRYPOINT ["java","-jar","/app.jar"]

# FROM openjdk:17-jdk-slim

# WORKDIR /app

# COPY build/libs/Configservice-0.0.1-SNAPSHOT.jar Configservice-0.0.1-SNAPSHOT.jar

# EXPOSE 8081

# ENTRYPOINT ["java", "-jar", "Configservice-0.0.1-SNAPSHOT.jar"]
