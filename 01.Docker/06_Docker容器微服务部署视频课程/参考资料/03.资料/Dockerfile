FROM java:8-alpine
VOLUME /tmp
ADD app.jar /app.jar
EXPOSE 9001
ENTRYPOINT ["java","-jar","/app.jar"]