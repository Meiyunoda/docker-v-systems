# primecoin/primecoind

Primecoind docker image. Provides a classic primecoin binary built from the [github/primecoin](https://github.com/primecoin/primecoin) repository.

## Usage

```sh
$ docker run --name primecoind \
  -v /home/ubuntu/docker-primecoind-data:/data \
  -p 9911:9911 \
  -p 9912:9912 \
  -d primecoin/primecoind \
  -txindex \
  -printtoconsole \
  -rpcallowip=0.0.0.0/0 \
  -rpcpassword=bar \
  -rpcuser=foo
```

## Supported tags

See <https://hub.docker.com/r/primecoin/primecoind/tags>

## Usage - More Explanations

### How to use this image

It behaves like a command, so you can pass any arguments to the image and they will be forwarded to the `primecoind` binary:

```sh
$ docker run --name primecoind -d primecoin/primecoind \
  -rpcallowip=0.0.0.0/0 \
  -rpcpassword=bar \
  -rpcuser=foo
```

Use the same command to start the testnet container:

```sh
$ docker run --name primecoind-testnet -d primecoin/primecoind \
  -rpcallowip=0.0.0.0/0 \
  -rpcpassword=bar \
  -rpcuser=foo \
  -testnet
```

By default, `primecoin` will run as as user `primecoin` for security reasons and store data in `/data`. If you'd like to customize where `primecoin` stores its data, use the `XPM_DATA` environment variable. The directory will be automatically created with the correct permissions for the user and `primecoin` automatically configured to use it.

```sh
$ docker run --env XPM_DATA=/var/lib/primecoin --name primecoind -d primecoin/primecoind
```

You can also mount a host directory at `/data` like so:

```sh
$ docker run -v /opt/primecoin:/data --name primecoind -d primecoin/primecoind
```
That will allow access to `/data` in the container as `/opt/primecoin` on the host.

```sh
$ docker run -v ${PWD}/data:/data --name primecoind -d primecoin/primecoind
```
will mount the `data` sub-directory at `/data` in the container.

To map container RPC ports to localhost use the `-p` argument with `docker run`:

```sh
$ docker run -p 9912:9912 --name primecoind -d primecoin/primecoind -rpcallowip=*
```
You may want to change the port that it is being mapped to if you already run a peercoin instance on the host.

For example: `-p 9999:9912` will map container port 9912 to host port 9999.

Now you will be able to `curl` peercoin in the container:

`curl --user foo:bar --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }'  -H 'content-type: text/plain;' localhost:9912/`

