FROM golang:alpine as builder
RUN apk update && apk add git glide cmake build-base
ENV GOPATH $HOME/go
ARG GIT_TAG
RUN go get -d github.com/aergoio/aergo
WORKDIR ${GOPATH}/src/github.com/aergoio/aergo
RUN git checkout ${GIT_TAG} && git submodule init && git submodule update && cmake .
RUN make polaris colaris

FROM alpine:3.8
RUN apk add libgcc
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/polaris /usr/local/bin/
COPY --from=builder $HOME/go/src/github.com/aergoio/aergo/bin/colaris /usr/local/bin/
WORKDIR /tools/
CMD ["polaris"]