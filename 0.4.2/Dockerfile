# Build stage for v systems
FROM ubuntu:20.04 as v-systems-build
RUN apt update && apt install -y wget

ENV V_SYSTEMS_VERSION=0.4.2
ENV V_SYSTEMS_SHA=8bc05ea0b94eba15a198c65499be4314600cee00eb799820b413432471d55c8e
ENV V_SYSTEMS_PREFIX=/opt/v-systems

RUN wget -q -O v-systems.jar https://github.com/virtualeconomy/v-systems/releases/download/v${V_SYSTEMS_VERSION}/v-systems-${V_SYSTEMS_VERSION}.jar \
    && echo "${V_SYSTEMS_SHA}  v-systems.jar" | sha256sum -c -

RUN mkdir -p ${V_SYSTEMS_PREFIX}/bin
RUN cp ./v-systems.jar ${V_SYSTEMS_PREFIX}/bin/v-systems.jar
RUN chmod ugo+rx ${V_SYSTEMS_PREFIX}/bin/

# Build stage for compiled artifacts
FROM ubuntu:20.04

RUN adduser --system vsystems && \
  apt update && \
  apt install -y openjdk-8-jre-headless gosu
RUN which java

ENV V_SYSTEMS_DATA=/data
ENV V_SYSTEMS_PREFIX=/opt/v-systems
ENV PATH=${V_SYSTEMS_PREFIX}/bin:$PATH

COPY --from=v-systems-build /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh
COPY v-systems.conf /v-systems.conf

VOLUME ["${V_SYSTEMS_DATA}"]

EXPOSE 9921 9922 9923 9924

RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["java"]
