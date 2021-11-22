FROM redhat/ubi8:8.5

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN dnf install -y tzdata openssl curl ca-certificates fontconfig glibc-langpack-en gzip tar \
    && dnf update -y; dnf clean all

LABEL name="Red Hat Base UBI" \
      vendor="SRBI" \
      version="ubi8" \
      release="8" \
      run="docker run --rm -ti <image_name:tag> /bin/bash" \
      summary="Base ubi" \
      description="Base UBI "
