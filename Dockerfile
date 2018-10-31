FROM alpine:3.8
RUN apk add --no-cache go glide git build-base
ENV GOPATH $HOME/go
ENV AERGOVERSION 3ef7fd35357041105c34d9504964c35f09b92bc0
WORKDIR ${GOPATH}
RUN go get -d github.com/aergoio/aergo
RUN cd src/github.com/aergoio/aergo && git checkout ${AERGOVERSION} && git submodule init && git submodule update && make && mv ./bin/* /usr/local/bin && cd / && rm -rf ${GOPATH}
ADD config.toml /aergo/config.toml
WORKDIR /aergo/
CMD ["aergosvr", "--config", "/aergo/config.toml"]
EXPOSE 7845 7846 6060 8080