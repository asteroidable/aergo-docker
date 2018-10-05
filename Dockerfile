FROM alpine:3.8
RUN apk add --no-cache go glide git build-base
ENV GOPATH $HOME/go
ENV AERGOVERSION 577db2d0ce7128156dd305485febe692962d56e6
WORKDIR ${GOPATH}
RUN go get -d github.com/aergoio/aergo
RUN cd src/github.com/aergoio/aergo && git checkout ${AERGOVERSION} && git submodule init && git submodule update && make deps && make && mv ./bin/* /usr/local/bin && cd / && rm -rf ${GOPATH}
ADD config.toml /aergo/config.toml
WORKDIR /
CMD ["aergosvr", "--config", "/aergo/config.toml"]
