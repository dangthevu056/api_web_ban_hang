# Build stage
FROM maven:3-openjdk-11 AS build
WORKDIR /app

# Chỉ copy các file cần thiết để tối ưu build cache
COPY pom.xml ./
COPY src ./src/

# Build dự án và bỏ qua kiểm tra test
RUN mvn clean package -DskipTests

# Run stage
FROM openjdk:11-jdk-slim
WORKDIR /app

# Copy file .war từ build stage
COPY --from=build /app/target/api_web_ban_hang-0.0.1-SNAPSHOT.war app.war

# Expose cổng 8080
EXPOSE 8080

# Chạy ứng dụng
ENTRYPOINT ["java", "-jar", "app.war"]
