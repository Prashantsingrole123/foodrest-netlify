# Step 1: Build stage
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Runtime stage
FROM eclipse-temurin:17-jdk

# Install ca-certificates to avoid MongoDB SSL errors
RUN apt-get update && apt-get install -y ca-certificates

WORKDIR /app
COPY --from=builder /app/target/foodiesapi-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
