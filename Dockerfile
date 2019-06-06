FROM openjdk:12.0.1-jdk-oraclelinux7
ADD target/restfulweb-1.0.0-SNAPSHOT.war /tmp/projetfinal.war
EXPOSE 8080
ENTRYPOINT ["/usr/bin/java","-jar","/tmp/projetfinal.war" "-spring.data.mongodb.uri=$MONGO_DB://$MONGO_ADMIN:$MONGO_PWD@$MONGO_URL:$MONGO_PORT/database"]
