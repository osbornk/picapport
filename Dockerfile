FROM debian:bullseye-slim AS build

ARG VERSION=10-4-00

RUN mkdir -p /opt/picapport/.picapport && \
    printf "%s\n%s\n%s\n" "server.port=$PICAPPORT_PORT" "robot.root.0.path=/srv/photos" "foto.jpg.usecache=2" > /opt/picapport/.picapport/picapport.properties

ADD https://www.picapport.de/download/${VERSION}/picapport-headless.jar /opt/picapport/picapport-headless.jar

FROM gcr.io/distroless/java17-debian11

ARG BUILD_DATE

ENV PICAPPORT_LANG="en"
ENV PICAPPORT_PORT=80
ENV DTRACE=WARNING
ENV XMS=256m
ENV XMX=1024m

COPY --from=build /opt/picapport /opt/picapport

ENV JDK_JAVA_OPTIONS="-Xms$XMS -Xmx$XMX -DTRACE=$DTRACE -Duser.home=/opt/picapport -Duser.language=$PICAPPORT_LANG"

CMD ["/opt/picapport/picapport-headless.jar"]

LABEL version=$VERSION \
      name="picapport" \
      build-date=$BUILD_DATE