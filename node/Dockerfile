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
ADD testnet.toml /aergo/testnet.toml
ADD testnet.toml /root/.aergo/config.toml
ADD testnet-genesis.json /aergo/testnet-genesis.json
ADD local.toml /aergo/local.toml
ADD testmode.toml /aergo/testmode.toml
WORKDIR /aergo/
CMD ["aergosvr", "--config", "/aergo/testnet.toml"]
EXPOSE 7845 7846 6060 8080