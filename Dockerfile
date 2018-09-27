FROM alpine:3.8
RUN apk add --no-cache go glide git build-base
ENV GOPATH $HOME/go
WORKDIR ${GOPATH}
RUN go get -d github.com/aergoio/aergo
RUN cd src/github.com/aergoio/aergo && git submodule init && git submodule update && make deps && make && mv ./bin/* /usr/local/bin && cd / && rm -rf ${GOPATH}
ADD config.toml /aergo/config.toml
WORKDIR /
CMD ["aergosvr", "--config", "/aergo/config.toml"]
