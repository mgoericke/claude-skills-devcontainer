# Dockerfile – product-service
# Speicherort: Projekt-Root (./Dockerfile)
#
# Co-Author: Claude (claude-sonnet-4-6, Anthropic)
#
# Build:  docker build -t product-service .
# Run:    docker run -p 8080:8080 product-service

# ── Build Stage ───────────────────────────────────────────────────────────────
FROM eclipse-temurin:25-jdk-alpine AS builder
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline -q
COPY src src
RUN ./mvnw package -DskipTests -q

# ── Runtime Stage ─────────────────────────────────────────────────────────────
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
# Health Check über Spring Boot Actuator /actuator/health
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health | grep '"status":"UP"' || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
