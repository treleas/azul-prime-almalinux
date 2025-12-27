# syntax=docker/dockerfile:1.20
ARG JAVA_DIST_VERSION
ARG ARCH_SUFFIX=""

FROM azul/prime:${JAVA_DIST_VERSION}${ARCH_SUFFIX} AS azul-extractor

RUN export JAVA_DIR=$(find /opt/zing -maxdepth 1 -type d -name "zing*-jre*") && \
    echo "Archiving Java from: $JAVA_DIR" && \
    cd $JAVA_DIR && \
    tar -cf /tmp/java.tar .

FROM almalinux:10.1 AS final

RUN dnf update -y && dnf clean all

ENV JAVA_HOME /usr/lib/jvm
ENV PATH $PATH:$JAVA_HOME/bin

RUN mkdir -p $JAVA_HOME

COPY --from=azul-extractor /tmp/java.tar /tmp/java.tar

RUN tar -xf /tmp/java.tar -C $JAVA_HOME && \
    rm /tmp/java.tar