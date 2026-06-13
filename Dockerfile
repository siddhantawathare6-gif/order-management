# Multi-stage Dockerfile: build with Maven, run using Distroless Java 17

FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src src
RUN mvn -B -DskipTests package -DskipTests

FROM gcr.io/distroless/java17-debian11:nonroot
COPY --from=build /workspace/target/*.jar /app/app.jar
EXPOSE 8080
USER nonroot
ENTRYPOINT ["java","-jar","/app/app.jar"]
