FROM ubuntu

MAINTAINER elodina

#Go settings
ENV GOLANG_VERSION 1.4
ENV GOLANG_RELEASE go$GOLANG_VERSION
ENV GOLANG_URL https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOROOT /usr/bin/go
ENV GOPATH /
ENV PATH $GOROOT/bin:$PATH

#Get git and mercurial
RUN sudo apt-get update
RUN sudo apt-get -y install git
RUN sudo apt-get -y install mercurial

#Install wget
RUN sudo apt-get -y install wget

#Get Go
RUN wget -q $GOLANG_URL -O /tmp/$GOLANG_RELEASE.tar.gz
RUN tar -xzf /tmp/$GOLANG_RELEASE.tar.gz -C /usr/bin
RUN mkdir -p $GOPATH/src

#Get godeps
RUN apt-get -y install build-essential
RUN go get github.com/tools/godep

ADD . /src/github.com/elodina/go-kafka-client-mesos

#Build
RUN cd /src/github.com/elodina/go-kafka-client-mesos && godep restore && go build cli.go && go build executor.go

#Set working dir
WORKDIR /src/github.com/elodina/go-kafka-client-mesos