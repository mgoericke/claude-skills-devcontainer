# ── Build Stage ───────────────────────────────────────────────────────────────
FROM eclipse-temurin:25-jdk-alpine AS builder
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline -q
COPY src src
RUN ./mvnw package -DskipTests -q

# ── Runtime Stage (Quarkus Fast-JAR) ─────────────────────────────────────────
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY --from=builder /app/target/quarkus-app/lib/ lib/
COPY --from=builder /app/target/quarkus-app/*.jar .
COPY --from=builder /app/target/quarkus-app/app/ app/
COPY --from=builder /app/target/quarkus-app/quarkus/ quarkus/
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "quarkus-run.jar"]
