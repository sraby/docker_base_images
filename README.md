The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia/docker_base_images

What images are built is controlled by the automated build settings on Docker Hub. Right now, each Dockerfile is manually added
and built based on tags that match it's name. For example, `ruby/2.2/Dockerfile` is built when a git tag
matching `ruby/2.2-0.1` is pushed, where 0.1 is the version we want to publish. Afterwords, application specific
Dockerfiles can reference the publically available image at `voxmediad/docker_base_images:ruby_2.2-0.1`.

## Docker test kitchen caveat

For some reason, Docker hub doesn't build the docker_test_kitchen image - it errors out wheneve it tries.
To update it:

- Built it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images` (this will _maybe_ overrite existing tags but I really hope not)

## The rails base image

The rails base image includes a system for managing a non-root internal docker user; and some standard entrypoint helper scripts. An example of an entrypoint using this image would look like this:

    #!/bin/sh
    set -e
    /opt/entrypoint/cleanup_pids.sh
    /opt/entrypoint/service_health_checks/mysql.sh
    /opt/entrypoint/sync_docker_user_with_host_user.sh
    exec /opt/entrypoint/exec_as_docker_user.sh $@

### Rails base image changelog

#### Version 0.4

* Use "gosu" in the final entrypoint exec instead of "sudo".

#### Version 0.3

* If the host user id is 0, skip the host user sync step. This probably means the host enviornment is OSX, where it doesn't matter if the container user and host user are synced.

#### Version 0.2

* The dockerfile now creates a non-root user (named "docker") and runs as that user
* Bundler configuration added (necessary to get bundler to work well in user context)
* New entrypoint script added to manage syncing the host user uid/gid with the internal user
* New entrypoint script added to exec as the internal user

#### Version 0.1

* Initial rails base image
* Sets locale C.UTF-8, adds docker-ssh-exec, adds entrypoint helper scripts
* Entrypoint script for cleaning stale pids that rails leaves around
* Entrypoint script for mysql service health check
