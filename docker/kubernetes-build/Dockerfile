## minimal build environment for kubernetes

# instructions:
#   (1) prepare kubernetes repo
#     mkdir -p /data/go/src/k8s.io
#     cd /data/go/src/k8s.io
#     git clone https://github.com/kubernetes/kubernetes
#     cd kubernetes
#     git checkout v1.18.3 # or whichever you tag you want to build
#   (2) build docker image
#     cd <dir-with-this-Dockerfile>
#     docker build -t go .
#   (3) start docker and build
#     docker run -it -v /:/host -u $(id -u) go:latest bash
#     export GOPATH=/host/data/go
#     export PATH=$PATH:/usr/lib/go-1.14/bin
#     cd $GOPATH/src/k8s.io/kubernetes
#     make
#   (4) binaries are in /data/go/src/k8s.io/kubernetes/_output/local/bin/linux/i386
#     (depending on your architecture/OS the path may differ)

FROM debian:buster

RUN echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/buster-backports.list
RUN apt-get update && apt-get install -y golang-1.14 make rsync git
