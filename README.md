# Docker image for aergo node

[![docker pulls](https://img.shields.io/docker/pulls/aergo/node.svg)](https://hub.docker.com/r/aergo/node/)
[![docker size](https://img.shields.io/microbadger/image-size/aergo/node.svg)](https://hub.docker.com/r/aergo/node/)
[![docker layers](https://img.shields.io/microbadger/layers/aergo/node.svg)](https://microbadger.com/images/aergo/node)

All runtime files are in the `/aergo` directory inside the Docker container. The easiest way to set this up is to override this directory with a local volume (e.g. `-v $(pwd)/:/aergo/`). Of course you can also override only specific files (`-v $(pwd)/config.toml:/aergo/config.toml`).

When requested, the container exposes the ports 7845 7846 6060 8080. Please refer to the Aergo documentation for details about their usage. You need to bind ports that you want to use to your Docker host (e.g. `-p 17845:7845` to bind the internal port 7845 to the host port 17845).

## Run

```console
docker run -p 7845:7845 aergo/node

# Override config file
docker run -p 7845:7845 -v $(pwd)/config.toml:/aergo/config.toml aergo/node

# Override all runtime files
docker run -p 7845:7845 -v $(pwd)/:/aergo/ aergo/node

# Run the cli
docker run --rm aergo/node aergocli version
docker run --rm aergo/node aergocli -H host_name -p host_bound_port blockchain

# Run the brick tool
docker run --rm -i --tty --workdir /tools aergo/node brick

# Run server in test mode
docker run --rm -p 7845:7845 aergo/node aergosvr --testmode
```

### Setup

Generate genesis block

```console
docker run --rm -v $(pwd)/:/aergo/ aergo/node aergosvr init /aergo/genesis.json --dir /aergo/data --config /aergo/config.toml
```

## Build and push a new version to Docker Hub

```console
docker build --build-arg AERGOVERSION=v0.8.0 -t aergo/node:0.8.0 .
docker image push aergo/node:0.8.0   # docker hub authentication required
```

`AERGOVERSION` refers to a git tag or commit.

You may need to run `docker login` before pushing to docker hub.

To build the latest master:

```console
docker build --build-arg AERGOVERSION=master -t aergo/node:latest .
docker image push aergo/node:latest
```

If `master` is cached in Docker, use a git commit hash instead.

BE CAREFUL when pushing already existing versions again. Docker Hub doesn't check what you push.
Make sure you don't inadvertenly override an image that people already use.
