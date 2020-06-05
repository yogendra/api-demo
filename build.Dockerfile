FROM maven:3-openjdk-11 as build
WORKDIR /build
# This will speedup build by caching jars
COPY pom.xml .
RUN mvn dependency:go-offline
# ----
COPY . /build
RUN mvn clean package

FROM adoptopenjdk/openjdk11:jre as runtime
EXPOSE 8080
COPY --from=build /build/target/api-demo-*.jar /app.jar
CMD [ "java" , "-jar" ,"/app.jar"]
