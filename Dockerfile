FROM  docker-registry:5000/adoptopenjdk/openjdk8-openj9:v7 as builder
COPY . /project

RUN cd /project && mvn -B install dependency:go-offline -DskipTests

WORKDIR /project

RUN mvn install -DskipTests
RUN cd /project/target
WORKDIR /project/target

RUN /opt/java/openjdk/bin/jar -xf starter-app.jar
RUN mv wlp/usr/servers/*/* /config/ 
RUN whoami
RUN  sudo chown -R 10000600:0 /config
RUN mkdir /logs 
RUN sudo chown -R 10000600:0 /logs


FROM open-liberty:kernel-java8-openj9

COPY --chown=10000600:0 --from=builder /config/ /config/
COPY --chown=10000600:0 --from=builder /logs /logs
EXPOSE 9080
EXPOSE 9443
