FROM openjdk:13
ADD target/restfulweb-1.0.0-SNAPSHOT.jar restfulweb-1.0.0-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","restfulweb-1.0.0-SNAPSHOT.jar","–spring.data.mongodb.uri=mongodb://costumer3:costumer3@192.168.60.4:27017/custumer"]
