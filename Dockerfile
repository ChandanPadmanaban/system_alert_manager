FROM eclipse-temurin:17

WORKDIR /app

COPY . .

# Create classes directory and compile java sources
RUN mkdir -p src/main/webapp/WEB-INF/classes && \
    find src/main/java -name "*.java" | xargs javac -cp "src/main/webapp/WEB-INF/lib/*" -d src/main/webapp/WEB-INF/classes

EXPOSE 8080

CMD ["sh", "-c", "java -jar jetty-runner.jar --port $PORT src/main/webapp"]