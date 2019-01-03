FROM golang:1.10-stretch as buildpack
RUN apt update && apt install -y git golang-glide cmake build-essential \
	&& apt clean && rm -rf /var/lib/apt/lists/*
ENV GOPATH $HOME/go


FROM buildpack as builder
ARG GIT_TAG
RUN go get -d github.com/aergoio/aergo
WORKDIR ${GOPATH}/src/github.com/aergoio/aergo
RUN git checkout --detach ${GIT_TAG} && git submodule init && git submodule update
RUN cmake . && make aergosvr
#RUN make
RUN git clone https://github.com/aergoio/aergo-docker.git ${GOPATH}/src/github.com/aergoio/aergo-docker


FROM alpine:3.8
RUN apk add libgcc libc6-compat
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/aergosvr /usr/local/bin/
#COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/aergocli /usr/local/bin/
#COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/aergoluac /usr/local/bin/
#COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/brick /usr/local/bin/
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo-docker/node/testnet.toml /aergo/testnet.toml
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo-docker/node/testnet.toml /root/.aergo/config.toml
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo-docker/node/testnet-genesis.json /aergo/testnet-genesis.json
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo-docker/node/local.toml /aergo/local.toml
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo-docker/node/testmode.toml /aergo/testmode.toml
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo-docker/node/arglog.toml /aergo/arglog.toml
WORKDIR /aergo/
CMD ["aergosvr", "--config", "/aergo/testnet.toml"]
EXPOSE 7845 7846 6060 8080

