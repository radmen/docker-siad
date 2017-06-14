# docker-siad

Simple wrapper for Siacoin Daemon.  
Built mostly for development.

**Warning** do not use this on production.

# API proxy

`siad` has a silly way of exposing its API. It's possible to define address on which API server should listen (`--api-addr`) however when it's different than default user needs to pass `--authenticate-api` and `--disable-api-security` options.

`--authenticate-api` requires password which can be set only by user input (can't use env variables or STDIN).

This means that running daemon inside Docker container may be quite a problem.

For this reason I created simple Node.js proxy which bypasses security requirements.  
**Node running this image should be considered insecure**.

# Running deamon

Container has exposed ports `9980`, `9981`, `9982` which are proxied to according ports of `siad` (`api`, `rpc`, `host`).

Daemon data are stored in a VOLUME `/siad/data`. I suggest to map this volume to local directory - thanks to this blockchain sync will be faster on next runs. Also note that ANY change done in `siad` (like unlocked wallet) will be stored there.

Running container:

```bash
docker run -it --rm -v "${PWD}/siad-data:/siad/data" -p 9980:9980 radmen/siad
```

Check status:

```bash
curl -A "Sia-Agent" "http://{docker.host}:9980/consensus"
```

## Supported options

It's possible to pass some options to `siad`:

```bash
docker run -it --rm -v "${PWD}/siad-data:/siad/data" -p 9980:9980 radmen/siad -M cghrtw
```

By default I wanted to allow passing all `siad` options but it didn't make sense so `siad` options list is limited to:

* `--agent`
* `--modules`/`-M` (**default**: `cgtw`)
* `--no-bootstrap`
* `--profile`
* `--profile-directory`

# Building image

Due to usage of [multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) it's required to have Docker with minimum version 17.05.

To build image:

```bash
docker build . -t radmen/siad
```
