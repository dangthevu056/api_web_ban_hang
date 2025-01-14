FROM maven:3-openjdk-17 AS build
WORKDIR /app

COPY . .
COPY ./lombok.config /app/
RUN mvn clean package -DskipTests


# Run stage

FROM openjdk:17-jdk-slim
WORKDIR /app

COPY --from=build /app/target/api_web_ban_hang-0.0.1-SNAPSHOT.war mobile.war
EXPOSE 8080
ENTRYPOINT ["java","-jar","mobile.war"]
