<div align="center">

<h1>Artifakt Demo App for Sylius Plus</h1>
<img src="./.github/logo.png" alt="artifakt-logo" width="100"/>

**Demo App for Sylius Plus by Artifakt PaaS**

[![Build Docker Images](https://github.com/artifakt-io/artifakt-docker-images/actions/workflows/nightly.yml/badge.svg)][Build status]
[![Twitter handle][]][Twitter badge]

</div>

## Getting started

Artifakt PaaS provides specialized [base docker images](https://github.com/artifakt-io/artifakt-docker-images) to build your application images. 

These base images are not usable alone, as they include no code or app. 

That's why Artifakt provides sample apps like this one to showcase how to build, test and deploy using our special features.

## Sylius Product Information Management

For complete documentation about the Sylius Plus project, please refer to official [README](https://github.com/Sylius/Sylius/blob/1.11/README.md) file

## Pre-requisites

To enjoy the best experience, a recent version of Docker (>=20.10) is required.
Older versions like 19.03 can work by enabling experimental features.

## Installation / Configuration

Container configuration tries to stick to 12-factor app principles as much as possible. Thus, you can edit a custom `.env` file containing Artifakt default env. variables.

Another important step for Sylius Plus is the `artifakt-custom-build-args.dist`. It must be copied and renamed to `artifakt-custom-build-args`. Then you can add the private repository token. This token is provided by Sylius when you acquire an Entreprise license.

## Pre-configured Docker compose stack

You can use this stack to run a complete Sylius stack with MySQL in a few docker-compose lines.

```
docker compose --env-file=.env up -d --build
```

## Adding custom code

Our standard Dockerfile defines a default workdir in /var/www/html to put your code into. By default, it is copied inside the custom docker image when you build it. The following command will build a close to production docker image on your local laptop:

```
DOCKER_BUILDKIT=1 docker build -t `basename $PWD`:latest --progress=plain .
```

We also have a development mode, with the included docker-compose file that will mount code inside the container directly, without the need to rebuild on each file update. This is a good practice and enables a fast iteration cycle.

## Persistent data

To persist data between container updates, we inittialize a /data/ folder inside the docker image. You can use it for images, assets, uploads, cache, etc.

## Building Workflow

What happens when you build the image with our standard Dockerfile?

1. base image is pulled from Artifakt free registry
2. local Dockerfile is built
3. if custom build args exists that are sourced from local repo
4. if a build.sh script is available, it is executed
5. overall, during build step we add code source and install packages and internal dependencies
6. if the special folder ‘.artifakt’ is found it is copied at the container root file system for later use.

End of build step!

## Starting workflow

Here is what happens when the container runs on your workstation. We apply the same workflow in production for predictible results.

1. environment variables for all dependencies are gathered: mysql, redis, elasticache, etc.
2. container is created with standard volumes on /data and /var/log/artifakt.
3. container is configured with standard env. variables
4. container is started and runs the base image entrypoint
5. base image entrypoint will look for a custom entrypoint script in /.artifakt folder and run it for you.

# Support and feedback

* [File an issue](https://github.com/artifakt-io/artifakt-docker-images/issues/new/choose)
* [Contact Artifakt Support](https://support.artifakt.io/)

[Build Status - Main]: https://github.com/artifakt-io/artifakt-docker-images/actions/workflows/nightly.yml/badge.svg?branch=main&event=push
[Build status]: https://github.com/artifakt-io/artifakt-docker-images/actions
[Twitter badge]: https://twitter.com/intent/follow?screen_name=artifakt_com
[Twitter handle]: https://img.shields.io/twitter/follow/artifakt_com.svg?style=social&label=Follow
