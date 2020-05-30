## minimal build environment for kubernetes

# instructions:
#   docker run -it -v /:/host -u $(id -u) go:latest bash
#   export GOPATH=/host/home/uwe/go
#   export PATH=$PATH:/usr/lib/go-1.14/bin
#   cd $GOPATH/src/k8s.io/kubernetes
#   make

FROM debian:buster

RUN echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/buster-backports.list
RUN apt-get update && apt-get install -y golang-1.14 make rsync
