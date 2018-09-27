FROM alpine:3.8
RUN apk add --no-cache go glide git build-base 
RUN go version
ENV GOPATH $HOME/go
WORKDIR ${GOPATH}
RUN go get -d github.com/aergoio/aergo
RUN cd src/github.com/aergoio/aergo && git submodule init && git submodule update
RUN cd src/github.com/aergoio/aergo && make deps && make
ADD config.toml /aergo/config.toml
ENTRYPOINT ["./src/github.com/aergoio/aergo/bin/aergosvr", "--config", "/aergo/config.toml"]