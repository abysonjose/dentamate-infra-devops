# ============================================
# DentaMate Java Spring Boot Dockerfile Template
# ============================================
# Usage: Copy this to your Java/Spring Boot service repo
# Optimized for Render deployment
# Multi-stage build for smaller image size
# ============================================

# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:21-slim

WORKDIR /app

# Copy JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (Render will override with PORT env var)
EXPOSE 8080

# Health check (optional but recommended)
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:${PORT:-8080}/actuator/health || exit 1

# Start application
# Spring Boot will automatically use PORT env var if set
CMD ["sh", "-c", "java -jar app.jar --server.port=${PORT:-8080}"]
