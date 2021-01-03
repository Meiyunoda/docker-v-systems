# Build stage for v systems
FROM ubuntu:20.04 as v-systems-build

RUN apt update && apt install -y gnupg curl
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt update && apt install -y git sbt openjdk-8-jre-headless

RUN git clone https://github.com/virtualeconomy/v-systems
WORKDIR /v-systems
ARG commit=master
RUN git checkout ${commit} && echo `git status`
ARG txtype=false
RUN if [ "$txtype" = "true" ]; then sed -i 's/tx-type-account-tx-ids = off/tx-type-account-tx-ids = on/g' src/main/resources/application.conf; fi
RUN cat src/main/resources/application.conf | grep tx-type-account-tx-ids
RUN sbt packageAll

ARG version=0.3.2
ENV V_SYSTEMS_PREFIX=/opt/v-systems
RUN mkdir -p ${V_SYSTEMS_PREFIX}/bin
RUN cp target/vsys-all-${version}.jar ${V_SYSTEMS_PREFIX}/bin/v-systems.jar
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
ARG txtype=false
RUN if [ "$txtype" = "true" ]; then sed -i 's/tx-type-account-tx-ids = off/tx-type-account-tx-ids = on/g' /v-systems.conf && sed -i 's/address-transaction-count = off/address-transaction-count = on/g' /v-systems.conf && sed -i 's/address-transaction-list = off/address-transaction-list = on/g' /v-systems.conf; fi
RUN cat /v-systems.conf | grep tx-type-account-tx-ids
RUN cat /v-systems.conf | grep address-transaction-

VOLUME ["${V_SYSTEMS_DATA}"]

EXPOSE 9921 9922 9923 9924

ENTRYPOINT ["/entrypoint.sh"]

CMD ["java"]
