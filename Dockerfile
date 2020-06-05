FROM adoptopenjdk/openjdk11:jre as runtime

ARG JAR_FILE
ADD $JAR_FILE /app.jar

EXPOSE 8080

CMD [ "java" , "-jar" ,"/app.jar"]
