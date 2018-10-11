FROM alpine:3.8
RUN apk add --no-cache go glide git build-base
ENV GOPATH $HOME/go
ENV AERGOVERSION 32d37d55df72eb0a46f510b3225dbaff8b7ce65d
WORKDIR ${GOPATH}
RUN go get -d github.com/aergoio/aergo
RUN cd src/github.com/aergoio/aergo && git checkout ${AERGOVERSION} && git submodule init && git submodule update && make && mv ./bin/* /usr/local/bin && cd / && rm -rf ${GOPATH}
ADD config.toml /aergo/config.toml
WORKDIR /
CMD ["aergosvr", "--config", "/aergo/config.toml"]
EXPOSE 7845 7846