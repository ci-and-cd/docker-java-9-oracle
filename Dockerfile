
FROM cirepo/nix:2.0.4_alpine-3.7

MAINTAINER haolun


USER root


ARG IMAGE_ARG_FILESERVER

# see: http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html
# http://download.oracle.com/otn/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.tar.gz?AuthParam=${auth_param}
# http://download.oracle.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz?AuthParam=${auth_param}
# jdk-9.0.4_linux-x64_bin.tar.gz sha256: 90c4ea877e816e3440862cfa36341bc87d05373d53389ec0f2d54d4e8c95daa2 #sha256sum -c /tmp/jdk-9.0.4_linux-x64_bin.tar.gz.sha256
ARG IMAGE_ARG_JAVA9_VERSION
ARG IMAGE_ARG_JAVA9_VERSION_BUILD
ARG IMAGE_ARG_JAVA9_PACKAGE_DIGEST


ENV JDK9_HOME /usr/lib/jvm/java-9-oracle
ENV JRE9_HOME /usr/lib/jvm/java-9-oracle-jre


COPY --from=cirepo/alpine-glibc:3.7_2.25-r0 /data/layer.tar /data/layer.tar
RUN tar xf /data/layer.tar -C /


RUN set -ex \
    && echo ===== Install JDK9 ===== \
        && cd /tmp \
        && JDK_ARCHIVE="jdk-${IMAGE_ARG_JAVA9_VERSION:-9.0.4}_linux-x64_bin.tar.gz" \
        && JDK_URL="${IMAGE_ARG_FILESERVER:-http://www.oracle.com}/otn/java/jdk/${IMAGE_ARG_JAVA9_VERSION:-9.0.4}+${IMAGE_ARG_JAVA9_VERSION_BUILD:-11}" \
        && if [ -n "${IMAGE_ARG_JAVA9_PACKAGE_DIGEST}" ]; then JDK_URL="${JDK_URL}/${IMAGE_ARG_JAVA9_PACKAGE_DIGEST:-c2514751926b4512b076cc82f959763f}"; fi \
        && JDK_URL="${JDK_URL}/${JDK_ARCHIVE}" \
        && ${ARIA2C_DOWNLOAD} --header="Cookie: oraclelicense=accept-securebackup-cookie" -d /tmp -o ${JDK_ARCHIVE} "${JDK_URL}" \
        && tar -xzf ${JDK_ARCHIVE} && mkdir -p $(dirname ${JDK9_HOME}) && mv /tmp/jdk-${IMAGE_ARG_JAVA9_VERSION:-9.0.4} ${JDK9_HOME} \
        && rm -f ${JDK9_HOME}/lib/src.zip \
        && rm -f ${JDK_ARCHIVE} && rm -rf /tmp/jdk* \
    && echo ===== Export jre  ===== \
        && cd $(dirname ${JDK9_HOME}) \
        && ${JDK9_HOME}/bin/jlink -p ${JDK9_HOME}/jmods --add-modules java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument,java.rmi,java.xml.bind,java.xml.ws,java.xml.ws.annotation --output java-9-oracle-jre \
    && rm -rf /tmp/* /var/cache/apk/*


ENV JAVA_HOME ${JDK9_HOME}
ENV PATH ${PATH}:${JAVA_HOME}/bin


USER alpine
