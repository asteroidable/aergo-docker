FROM golang:alpine as builder
RUN apk update && apk add git glide cmake build-base
ENV GOPATH $HOME/go
ARG GIT_TAG
RUN go get -d github.com/aergoio/aergo
WORKDIR ${GOPATH}/src/github.com/aergoio/aergo
RUN git checkout ${GIT_TAG} && git submodule init && git submodule update && cmake .
RUN make aergocli aergoluac brick

FROM alpine:3.8
RUN apk add libgcc
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/aergocli /usr/local/bin/
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/aergoluac /usr/local/bin/
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/brick /usr/local/bin/
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/cmd/brick/arglog.toml /tools/arglog.toml
WORKDIR /tools/
CMD ["aergocli"]