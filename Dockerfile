# syntax=docker/dockerfile:1

ARG VERSION=5.1.2

###
FROM ubuntu:24.04 as builder
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  btrfs-progs \
  crun \
  git \
  golang-go \
  go-md2man \
  iptables \
  libassuan-dev \
  libbtrfs-dev \
  libc6-dev \
  libdevmapper-dev \
  libglib2.0-dev \
  libgpgme-dev \
  libgpg-error-dev \
  libprotobuf-dev \
  libprotobuf-c-dev \
  libseccomp-dev \
  libselinux1-dev \
  libsystemd-dev \
  netavark \
  pkg-config \
  uidmap

RUN apt-get install -y \
	libapparmor-dev

RUN apt-get install -y \
	build-essential

ARG VERSION
ARG HOSTOS
ARG HOSTARCH

WORKDIR /app
# https://podman.io/docs/installation
RUN git clone https://github.com/containers/podman.git /app
RUN git checkout -b v${VERSION} v${VERSION}

#
ENV VERSION=${VERSION}
ENV GOOS=${HOSTOS}
ENV GOARCH=${HOSTARCH}

# ENV DESTDIR=/egress
# ENV PREFIX=/egress
# RUN make vendor

RUN make BUILDTAGS="" all

RUN mkdir /egress && mv bin/${HOSTOS}/podman /egress
#
CMD [ "bash" ]
