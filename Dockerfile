# =================
# 1. 빌드(Builder) 스테이지
# =================
FROM openjdk:21-jdk AS builder

WORKDIR /app

RUN microdnf install -y findutils

COPY gradlew ./
COPY gradle ./gradle
COPY build.gradle ./
COPY settings.gradle ./

RUN ./gradlew dependencies

COPY src ./src

RUN ./gradlew bootjar

# =================
# 2. 실행(Runner) 스테이지
# =================
FROM openjdk:21-slim

WORKDIR /app

EXPOSE ${REPORT_SERVICE_PORT}

COPY --from=builder /app/build/libs/*.jar report-service.jar

ENTRYPOINT ["java", "-jar", "report-service.jar"]