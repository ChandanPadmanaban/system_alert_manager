FROM eclipse-temurin:17

WORKDIR /app

COPY . .

EXPOSE 8080

CMD ["java", "-jar", "jetty-runner.jar", "--port", "8080", "src/main/webapp"]