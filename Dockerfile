FROM  docker-registry:5000/adoptopenjdk/openjdk8-openj9:v1 as builder

COPY . /project

RUN  /project/util/check_version build

RUN cd /project && mvn -B install dependency:go-offline -DskipTests

WORKDIR /project/user-app

RUN mvn install -DskipTests

RUN cd target && \
    unzip *.zip && \
    mkdir /config && \
    mv wlp/usr/servers/*/* /config/

FROM open-liberty:kernel-java8-openj9

COPY --chown=10000600:0 --from=builder /config/ /config/

EXPOSE 9080
EXPOSE 9443
