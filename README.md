# Docker image for aergo node

All runtime files are in the `/aergo` directory inside the Docker container. The easiest way to set this up is to override this directory with a local volume (e.g. `-v $(pwd)/:/aergo/`). Of course you can also override only specific files (`-v $(pwd)/config.toml:/aergo/config.toml`).

When requested, the container exposes the ports 7845 7846 6060 8080. Please refer to the Aergo documentation for details about their usage. You need to bind ports that you want to use to your Docker host (e.g. `-p 17845:7845` to bind the interal port 7845 to the host port 17845).

## Run

```console
docker run -p 7845:7845 aergo/node

# Override config file
docker run -p 7845:7845 -v $(pwd)/config.toml:/aergo/config.toml aergo/node

# Override all runtime files
docker run -p 7845:7845 -v $(pwd)/:/aergo/ aergo/node

# Run the cli
docker run aergo/node aergocli version
docker run aergo/node aergocli -H host_name -p host_bound_port blockchain
```

### Setup

Generate genesis block

```console
docker run -v $(pwd)/:/aergo/ aergo/node aergosvr init /aergo/genesis.json --dir /aergo/data --config /aergo/config.toml
```

## Build

```console
docker build -t aergo/node .
docker image push aergo/node  # docker hub authentication required
```
