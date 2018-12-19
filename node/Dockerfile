FROM golang:alpine as builder
RUN apk update && apk add git glide cmake build-base
ENV GOPATH $HOME/go
ARG GIT_TAG
RUN go get -d github.com/aergoio/aergo
WORKDIR ${GOPATH}/src/github.com/aergoio/aergo
RUN git checkout ${GIT_TAG} && git submodule init && git submodule update && cmake .
RUN make aergosvr

FROM alpine:3.8
RUN apk add libgcc
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/aergosvr /usr/local/bin/
ADD config.toml /aergo/config.toml
WORKDIR /aergo/
CMD ["aergosvr", "--config", "/aergo/config.toml"]
EXPOSE 7845 7846 6060 8080