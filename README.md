# Docker image for aergo node

[![docker pulls](https://img.shields.io/docker/pulls/aergo/node.svg)](https://hub.docker.com/r/aergo/node/)
[![docker size](https://img.shields.io/microbadger/image-size/aergo/node.svg)](https://hub.docker.com/r/aergo/node/)
[![docker layers](https://img.shields.io/microbadger/layers/aergo/node.svg)](https://microbadger.com/images/aergo/node)

The docker image **aergo/node** contains the main server binary, `aergosvr`.

All runtime files are in the `/aergo` directory inside the Docker container. The easiest way to set this up is to override this directory with a local volume (e.g. `-v $(pwd)/:/aergo/`). Of course you can also override only specific files (`-v $(pwd)/config.toml:/aergo/config.toml`).

When requested, the container exposes the ports 7845 7846 6060 8080. Please refer to the Aergo documentation for details about their usage. You need to bind ports that you want to use to your Docker host (e.g. `-p 17845:7845` to bind the internal port 7845 to the host port 17845).

## Run

```console
docker run -p 7845:7845 aergo/node

# Override config file
docker run -p 7845:7845 -v $(pwd)/config.toml:/aergo/config.toml aergo/node

# Override all runtime files
docker run -p 7845:7845 -v $(pwd)/:/aergo/ aergo/node

# Run server in test mode
docker run --rm -p 7845:7845 aergo/node aergosvr --config /aergo/config.toml --testmode
```

### Setup

Generate genesis block

```console
docker run --rm -v $(pwd)/:/aergo/ aergo/node aergosvr init /aergo/genesis.json --dir /aergo/data --config /aergo/config.toml
```

# Docker image for aergo tools

[![docker pulls](https://img.shields.io/docker/pulls/aergo/tools.svg)](https://hub.docker.com/r/aergo/tools/)
[![docker size](https://img.shields.io/microbadger/image-size/aergo/tools.svg)](https://hub.docker.com/r/aergo/tools/)
[![docker layers](https://img.shields.io/microbadger/layers/aergo/tools.svg)](https://microbadger.com/images/aergo/tools)

The docker image **aergo/tools** contains the binaries for **aergocli, aergoluac, brick**.

## Run

```console
# Run the cli
docker run --rm aergo/tools aergocli version
docker run --rm aergo/tools aergocli -H host_name -p host_bound_port blockchain

# Run the brick tool
docker run --rm -i --tty --workdir /tools aergo/node brick
```

# Build and push a new version to Docker Hub

**node**

```console
docker build --build-arg GIT_TAG=v0.8.3 -t aergo/node:0.8.3 node
docker image push aergo/node:0.8.3
```

**tools**

```console
docker build --build-arg GIT_TAG=v0.8.3 -t aergo/tools:0.8.3 tools
docker image push aergo/tools:0.8.3
```

GIT_TAG can refer to either a tag or commit hash.

You may need to run `docker login` before pushing to docker hub.

To build the latest master for testing, assign the next version with the `-rc` tag:

```console
docker build --build-arg GIT_TAG=latest_git_hash -t aergo/node:0.8.2-rc .
docker image push aergo/node:0.8.2-rc
```

BE CAREFUL when pushing already existing versions again. Docker Hub doesn't check what you push.
Make sure you don't inadvertenly override an image that people already use. DO NOT run `docker image push aergo/node`,
it pushes all tags that you have locally. Always push a specific tag.

`latest` should always point to a stable version, so only re-assign it AFTER a version has been tested and released.

[![Versioning scheme](https://msdnshared.blob.core.windows.net/media/2018/03/StableTagging.gif)](https://blogs.msdn.microsoft.com/stevelasker/2018/03/01/docker-tagging-best-practices-for-tagging-and-versioning-docker-images/)
