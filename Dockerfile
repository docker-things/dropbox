# FROM ubuntu:18.04
FROM alpine:3.8
MAINTAINER Gabriel Ionescu <gabi.ionescu+docker@protonmail.com>

# ARGS
ARG DOCKER_USERID
ARG DOCKER_GROUPID
ARG DOCKER_USERNAME

# ADD LAUNCHER
COPY scripts/launcher.sh /usr/bin/dropbox-launcher

# ENV
ENV LANG=C.UTF-8

RUN VERSION="2.28-r0" \
 \
 && echo -e "\n > INSTALL DEPENDENCIES\n" \
 && apk add --no-cache wget ca-certificates \
 \
 && echo -e "\n > ADD GLIBC PUBLIC KEY\n" \
 && echo \
        "-----BEGIN PUBLIC KEY-----\
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
        y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
        tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
        m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
        KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
        Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
        1QIDAQAB\
        -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub" \
 \
 && echo -e "\n > DOWNLOAD GLIBC\n" \
 && wget \
        "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$VERSION/glibc-$VERSION.apk" \
        "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$VERSION/glibc-bin-$VERSION.apk" \
        "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$VERSION/glibc-i18n-$VERSION.apk" \
 \
 && echo -e "\n > INSTALL GLIBC\n" \
 && apk add --no-cache glibc-*.apk \
 \
 && echo -e "\n > CONFIG GLIBC\n" \
 && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
 && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
 \
 && echo -e "\n > CHMOD DROPBOX LAUNCHER\n" \
 && chmod +x /usr/bin/dropbox-launcher \
 \
 && echo -e "\n > CREATE USER\n" \
 && addgroup -g $DOCKER_GROUPID $DOCKER_USERNAME \
 && adduser -D -h /dbox -u $DOCKER_USERID -G $DOCKER_USERNAME $DOCKER_USERNAME \
 && echo "plugdev:x:46:$DOCKER_USERNAME" > /etc/group \ \
 \
 && echo -e "\n > CLEANUP\n" \
 && apk del \
        glibc-i18n \
        ca-certificates \
 && rm -rf \
        glibc-*.apk \
        /etc/apk/keys/sgerrand.rsa.pub \
        /root/.wget-hsts \
        /tmp/* \
        /var/tmp/*

# SWITCH USER
USER $DOCKER_USERNAME

# SET WORK DIR
WORKDIR /dbox

# PORTS
EXPOSE 17500

# LAUNCH
CMD ["/bin/ash", "/usr/bin/dropbox-launcher"]
