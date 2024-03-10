FROM docker.io/library/alpine:latest

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories 
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories 
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk --no-cache --update --upgrade add icu-data-full

RUN apk --no-cache --purge -u add bash openbox tigervnc supervisor xterm terminus-font
RUN apk --no-cache --purge -u add gosu

RUN apk --no-cache add firefox-esr
#RUN apk --no-cache add blackbox-terminal mesa-dri-gallium dbus dbus-x11
RUN apk --no-cache add numix-themes-openbox font-cantarell feh

COPY etc /etc/
COPY usr /usr/

RUN ls -ila /usr/bin
RUN apk --no-cache add g++ libx11-dev
WORKDIR /usr/bin
RUN g++ screen_resolution.c -o screen_resolution -lX11

# Add support for LDAP / Kerberos
RUN apk --no-cache add openssl
RUN apk --no-cache add krb5 pam-krb5

ENV OWNER="admin"

# Debug:
# A local account with a password.
# Note: Randomize this password or better, disable it.
#       Will most likly conflict with LDAP user in some way
RUN adduser -D $OWNER
RUN echo "$OWNER:$(openssl passwd -1 123)" | chpasswd -e

LABEL se.domain.app-type="user"

CMD [ "sh", "-c", "chown $OWNER:$OWNER /dev/stdout && exec gosu \"$(id -u $OWNER):$(id -g $OWNER)\" supervisord" ]