# docker-dev-utils
Scripts to easily manage Docker containers used as a development environment
* `Makefile` - Used by the `make` command, this file defines commands for managing a container dev environment.  It's essentially an easy wrapper around the existing `docker` capabilities.
  * `make` - runs `create`, then `install`, then `start`.  If the container exists, then just runs `start`.
  * `make create` - creates a new container from the Gitpod image, named based on the current working directory.
  * `make install` - if a known package manager file is found, run the install command.  Recognizes `pipenv`, `bundler`, or `npm`.
  * `make start` - start the existing container.
  * `make run` - start a temporary container based on the same parameters as `make create`.
  * `make clean` - removes the existing container.
* `docker-dev` - a `bash` script for starting a container.  Similar to the Makefile, but with less awareness of existing containers.
