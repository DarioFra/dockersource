ARG DISTRO=alpine:3.12
FROM $DISTRO

# python3 shared with most images
RUN apk add --no-cache \
    python3 py3-pip bash \
  && pip3 install --upgrade pip

# Image specific layers under this line
RUN apk add --no-cache ca-certificates openssl isync \
 && pip3 install requests

COPY mbinit.sh /

COPY .mbsyncrc /
