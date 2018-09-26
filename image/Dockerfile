
FROM cirepo/nix:2.1.1-alpine-3.8


USER root


ARG IMAGE_ARG_FILESERVER

# see: http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html
# http://download.oracle.com/otn/java/jdk/9.0.1+11/jdk-9.0.1_linux-x64_bin.tar.gz?AuthParam=${auth_param}
# http://download.oracle.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz?AuthParam=${auth_param}
# jdk-9.0.4_linux-x64_bin.tar.gz sha256: 90c4ea877e816e3440862cfa36341bc87d05373d53389ec0f2d54d4e8c95daa2 #sha256sum -c /data/jdk-9.0.4_linux-x64_bin.tar.gz.sha256
# http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/
# http://funtoo.neu.edu.cn/funtoo/distfiles/oracle-java/
ARG IMAGE_ARG_JAVA9_VERSION
ARG IMAGE_ARG_JAVA9_VERSION_BUILD
#ARG IMAGE_ARG_JAVA9_PACKAGE_DIGEST


ENV JDK9_HOME /usr/lib/jvm/java-9-oracle
ENV JRE9_HOME /usr/lib/jvm/java-9-oracle-jre
ENV JAVA_HOME ${JDK9_HOME}
ENV PATH ${JDK9_HOME}/bin:${PATH}


COPY --from=cirepo/glibc:2.25-r0-alpine-3.8-archive /data/root /


COPY --chown=root:root docker /data


RUN set -ex \
  && echo ===== Install JDK9 ===== \
  && JDK_ARCHIVE="jdk-${IMAGE_ARG_JAVA9_VERSION:-9.0.4}_linux-x64_bin.tar.gz" \
  && if [ ! -f /data/${JDK_ARCHIVE} ]; then \
       ${ARIA2C_DOWNLOAD} -d /data -o ${JDK_ARCHIVE} http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/${JDK_ARCHIVE}; \
     fi \
  && tar -xzf /data/${JDK_ARCHIVE} -C /data && mkdir -p $(dirname ${JDK9_HOME}) && mv /data/jdk-${IMAGE_ARG_JAVA9_VERSION:-9.0.4} ${JDK9_HOME} \
  && rm -f ${JDK9_HOME}/lib/src.zip \
  && rm -f /data/${JDK_ARCHIVE} && rm -rf /data/jdk* \
  && JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}') \
  && echo OSX style JAVA_HOME is /Library/Java/JavaVirtualMachines/jdk-${JAVA_VERSION}.jdk/Contents/Home \
  && mkdir -p /Library/Java/JavaVirtualMachines/jdk-${JAVA_VERSION}.jdk/Contents \
  && ln -s ${JDK9_HOME} /Library/Java/JavaVirtualMachines/jdk-${JAVA_VERSION}.jdk/Contents/Home \
  && echo AppVeyor style JAVA_HOME \
  && ln -s ${JDK9_HOME} /usr/lib/jvm/java-9-openjdk-amd64 \
  && echo ===== Export jre  ===== \
  && cd $(dirname ${JDK9_HOME}) \
  && ${JDK9_HOME}/bin/jlink -p ${JDK9_HOME}/jmods --add-modules java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument,java.rmi,java.xml.bind,java.xml.ws,java.xml.ws.annotation --output java-9-oracle-jre \
  && rm -rf /tmp/* /var/cache/apk/* \
  && echo OSX style JAVA_HOME is /Library/Java/JavaVirtualMachines/jre-${JAVA_VERSION}.jre/Contents/Home \
  && mkdir -p /Library/Java/JavaVirtualMachines/jre-${JAVA_VERSION}.jre/Contents \
  && ln -s ${JRE9_HOME} /Library/Java/JavaVirtualMachines/jre-${JAVA_VERSION}.jre/Contents/Home \
  && echo AppVeyor style JAVA_HOME \
  && ln -s ${JRE9_HOME} /usr/lib/jvm/java-9-openjdk-amd64-jre

ENV JAVA_HOME ${JDK9_HOME}


USER alpine

#  && JDK_URL="${IMAGE_ARG_FILESERVER:-http://download.oracle.com}/otn/java/jdk/${IMAGE_ARG_JAVA9_VERSION:-9.0.4}+${IMAGE_ARG_JAVA9_VERSION_BUILD:-11}" \
#  && if [ -n "${IMAGE_ARG_JAVA9_PACKAGE_DIGEST}" ]; then JDK_URL="${JDK_URL}/${IMAGE_ARG_JAVA9_PACKAGE_DIGEST:-c2514751926b4512b076cc82f959763f}"; fi \
#  && JDK_URL="${JDK_URL}/${JDK_ARCHIVE}" \
#  && if [ ! -f /data/${JDK_ARCHIVE} ]; then \
#       ${ARIA2C_DOWNLOAD} --header="Cookie: oraclelicense=accept-securebackup-cookie" -d /data -o ${JDK_ARCHIVE} "${JDK_URL}"; \
#     fi \
