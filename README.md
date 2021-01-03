# vsystems/v-systems

V Systems docker image. Provides standard docker builds from the [v systems github](https://github.com/virtualeconomy/v-systems) repository.

## Usage

```sh
$ docker run --name v-systems-0.3.2 \
  -v docker-v-systems-data:/data \
  -p 9921:9921 \
  -p 9922:9922 \
  -d vsystems/v-systems-0.3.2
```

## Usage - More Explanations

### How to use the public images

By default, `java` will run as as user `vsystems` for security reasons and store data in `/data`. If you'd like to customize where `java` stores its data, use the `V_SYSTEMS_DATA` environment variable. The directory will be automatically created with the correct permissions for the user and `vsystems` automatically configured to use it.

```sh
$ docker run --env V_SYSTEMS_DATA=/var/lib/v-systems --name v-systems-0.3.2 -d vsystems/v-systems-0.3.2
```

You can also mount a host directory at `/data` like so:

```sh
$ docker run -v /opt/v-systems:/data --name vsystemsd -d vsystems/v-systems-0.3.2
```
That will allow access to `/data` in the container as `/opt/v-systems` on the host.

```sh
$ docker run -v ${PWD}/data:/data --name vsystemsd -d vsystems/v-systems-0.3.2
```
will mount the `data` sub-directory at `/data` in the container.

You may want to change the port that it is being mapped to if you already run a v systems instance on the host.

For example: `-p 9999:9922` will map container port 9922 to host port 9999.

Now you will be able to `curl` v systems in the container:

`curl http://localhost:9999/blocks/height`

## Support for development build

The dev build for development of v systems uses latest master branch of v systems official repo. To build for a specific commit, or branch/tag name:

```sh
docker build dev --build-arg commit=<commit/branch/tag>
```

To build for txtype index and api support which are required for most wallet server nodes:

```sh
docker build dev --build-arg txtype=true -t vsystems/v-systems-dev-txserver
```
