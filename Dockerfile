FROM adoptopenjdk/openjdk11:jre as runtime



RUN useradd -ms /bin/bash appuser

ARG JAR_FILE
ADD $JAR_FILE /app.jar

EXPOSE 8080

USER appuser

CMD [ "java" , "-jar" ,"/app.jar"]
