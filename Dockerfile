# Stage 1: Build
FROM maven:3-openjdk-11 AS build
WORKDIR /app

# Copy pom.xml and resolve dependencies (cache optimization)
COPY pom.xml ./
RUN mvn dependency:resolve
COPY lombok.config ./

# Copy source code
COPY src ./src/

# Build project
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM openjdk:11-jdk-slim
WORKDIR /app

# Copy the WAR file from the build stage
COPY --from=build /app/target/api_web_ban_hang-0.0.1-SNAPSHOT.war app.war

# Expose application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.war"]
