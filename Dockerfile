FROM  docker-registry:5000/adoptopenjdk/openjdk8-openj9:v5 as builder

COPY . /project

RUN cd /project && mvn -B install dependency:go-offline -DskipTests

WORKDIR /project

RUN mvn install -DskipTests
RUN cd /project/target
WORKDIR /project/target

#RUN sleep 9999999
RUN /opt/java/openjdk/bin/jar -xf starter-app.jar
RUN mv wlp/usr/servers/*/* /config/  

FROM open-liberty:kernel-java8-openj9

COPY --chown=10000600:0 --from=builder /config/ /config/

EXPOSE 9080
EXPOSE 9443
