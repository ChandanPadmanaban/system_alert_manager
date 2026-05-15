@echo off
echo Starting Cyber Security Monitoring System...
echo Access at: http://localhost:8080/
java -jar jetty-runner.jar --port 8080 src/main/webapp
pause
