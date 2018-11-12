FROM golang:alpine as builder
RUN apk update && apk add git glide cmake build-base
ENV GOPATH $HOME/go
ARG AERGOVERSION
RUN go get -d github.com/aergoio/aergo && cd ${GOPATH}/src/github.com/aergoio/aergo && git checkout ${AERGOVERSION} && git submodule init && git submodule update && cmake . && make

FROM alpine:3.8
RUN apk add libgcc
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/* /usr/local/bin/
ADD config.toml /aergo/config.toml
WORKDIR /aergo/
CMD ["aergosvr", "--config", "/aergo/config.toml"]
EXPOSE 7845 7846 6060 8080