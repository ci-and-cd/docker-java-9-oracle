# docker-java-9-oracle

Oracle JDK9 on alpine linux

Oracle JDK9 installed at `/usr/lib/jvm/java-9-oracle` (travis-ci style JAVA_HOME)


Dockerfile [ci-and-cd/docker-java-9-oracle on Github](https://github.com/ci-and-cd/docker-java-9-oracle)

[cirepo/java-oracle on Docker Hub](https://hub.docker.com/r/cirepo/java-oracle/)


The main caveat to note is that it does use musl libc instead of glibc and friends,
so certain software might run into issues depending on the depth of their libc requirements.
However, most software doesn't have an issue with this,
so this variant is usually a very safe choice.


## Use this image as a “stage” in multi-stage builds

```dockerfile

FROM alpine:3.8
COPY --from=cirepo/glibc:2.25-r0-alpine-3.8-archive /data/root /
COPY --from=cirepo/java-oracle:9.0.4-alpine-3.8-archive /data/root/usr/lib/jvm/java-9-oracle /usr/lib/jvm/java-9-oracle
COPY --from=cirepo/java-oracle:9.0.4-alpine-3.8-archive /data/root/usr/lib/jvm/java-9-oracle-jre /usr/lib/jvm/java-9-oracle-jre

```

## Java9 and glibc issues on alpine

see: https://github.com/sgerrand/alpine-pkg-glibc/issues/75
see: https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/9/jdk/alpine/Dockerfile.openj9#L32

