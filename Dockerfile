FROM openjdk:17-jdk-slim

WORKDIR /app

COPY build/libs/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java","-jar","/app.jar"]

# FROM openjdk:17-jdk-slim

# WORKDIR /app

# COPY build/libs/Configservice-0.0.1-SNAPSHOT.jar Configservice-0.0.1-SNAPSHOT.jar

# EXPOSE 8081

# ENTRYPOINT ["java", "-jar", "Configservice-0.0.1-SNAPSHOT.jar"]
