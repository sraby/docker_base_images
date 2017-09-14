The Dockerfiles in this repo are built and published publicly at https://hub.docker.com/r/voxmedia/docker_base_images

## Docker Test Kitchen Images

For some reason, Docker hub doesn't build the docker_test_kitchen image - it errors out wheneve it tries.
To update it:

- Built it locally with a `docker build .` and note the resulting ID.
- Run `docker tag ID voxmedia/docker_base_images:docker_test_kitchen-VERSION`
- `docker push voxmedia/docker_base_images` (this will _maybe_ overrite existing tags but I really hope not)

## Ruby Images

What images are built is controlled by the automated build settings on Docker Hub. Right now, each Dockerfile is manually added and built based on tags that match it's name. For example, `ruby/Dockerfile` is built when a git tag matching `ruby/2.2-0.1` is pushed, where 2.2 is the version of ruby, and where 0.1 is the version we want to publish. Afterwords, application specific Dockerfiles can reference the publically available image at `voxmedia/docker_base_images:ruby_2.2-0.1`.

### Updating the images
- Make your changes
- Bump the version in `VERSION`
- Run `ruby/trigger_builds.sh`

`trigger_builds` will create the appropriate tags and push them to github, which will then trigger the automated build process on Docker Hub.

### Building the images locally

If you'd like to build and test images locally, the Dockerfile uses a build arg to determine the version of ruby you want to use.  The following example builds image for ruby 2.3:

```
 git clone git@github.com:voxmedia/docker_base_images.git
 cd docker_base_images/ruby
 docker build . --build-arg RUBY_VERSION=2.3
 ```

The ruby base images include docker-ssh-exec and some standard entrypoint scripts. An example of an entrypoint script
using this image would look like this:

    #!/bin/sh
    set -e
    /opt/entrypoint/cleanup_pids.sh
    /opt/entrypoint/service_health_checks/mysql.sh
    exec docker-ssh-exec bundle exec "$@"

Note that this example includes `docker-ssh-exec` directly in the exec command, to make keys available to all commands without having to remember which commands require it and reference docker-ssh-exec manually.

### Ruby base images changelog

#### Version 0.3 (`ruby_2.2-0.3` and `ruby_2.3-0.3` and `ruby-2.4-0.3`)

* Moved all the functionality of the `rails` image into the base `ruby` images

### Rails base image changelog (RETIRED)

#### Version 0.3

* Adds `install_phantomjs.sh` build script.

#### Version 0.2

* Adds a `build_scripts` directory with an `install_node.sh` script. It's not run automatically--child images can choose to run if it necessary.


#### Version 0.1

* Initial rails base image
* Sets locale C.UTF-8, adds docker-ssh-exec, adds entrypoint helper scripts
* Entrypoint script for cleaning stale pids that rails leaves around
* Entrypoint script for mysql service health check
