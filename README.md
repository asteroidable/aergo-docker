# Docker image for aergo node

## Run

```console
docker run -p 7845:7845 aergo/node

# Override config file
docker run -p 7845:7845 -v $(pwd)/config.toml:/aergo/config.toml aergo/node

# Run the cli
docker run aergo/node aergocli version
```

## Build

```console
docker build -t aergo/node .
docker image push aergo/node  # docker hub authentication required
```
