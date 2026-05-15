FROM eclipse-temurin:17

WORKDIR /app

COPY . .

EXPOSE 8080

CMD ["sh", "-c", "java -jar jetty-runner.jar --port $PORT src/main/webapp"]