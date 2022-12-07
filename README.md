
# Dockerfile for openembedded development

[oe][oem] is a distribution-generator to build images of several distributions for 
embedded devices

This is a Dockerfile to generate an oe development environment for systems
other than ubuntu based. \
You can run bitbake etc. within this image.\
For developing you should use your native system, only building shall be done
inside the container, i. e. source files and build results shall be located on
local shares __outside__ the container.\
Therefore local folders will be mapped into
the container at image start time, see below.

[oem]: http://www.openembedded.org "OE Homepage"

## How to build the docker image:

    $ clone this repository
    $ cd oe-base
    $ docker build --no-cache  -t oe-dmo .
    $
    
## Show images, e.g.:

    $ docker images
    REPOSITORY                TAG       IMAGE ID       CREATED         SIZE
    oe-dmo-focal              latest    252e18ce2f05   3 months ago    1.18GB
    $


## Start an image and map host-directories into the container, e.g.:

    docker run -d -t -v /development:/development -v /build-yocto:/build-yocto oe-dmo-focal:latest
This starts the container and maps the folders /development and /build-yocto of the host system to /development and /build-yocto inside the container, so that these can be accessed from inside the container as well as on the host system.

## Show running containers, e.g.:

    $ docker ps -a
    CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS                     PORTS     NAMES
    512109d2bddd   oe-dmo-focal:latest    "/usr/sbin/sshd -D"      3 months ago    Exited (0) 5 weeks ago               relaxed_black
    $

## Start a container, e.g. by name:

    $ docker start relaxed_black 
    relaxed_black
    $
    
or by ID:

    $ docker start 512109d2bddd 
    512109d2bddd
    $
    
## Find the IP-address to connect to via ssh, e.g.:

    $ docker inspect relaxed_black
    ...
                "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "37ac7c78abd9cd01ebbe68350bb8073d0473629a5aff6bd1e2f308878f9cb2ab",
                    "EndpointID": "46fb9105515e286a25b2059d91b69cb171e7ab0f0e1023114287774102973ac3",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
    $

## Connect to container via ssh, e.g.:

    $ ssh -XA oe@172.17.0.2
    X11 forwarding request failed on channel 0
    Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.15.0-53-generic x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage

    This system has been minimized by removing packages and content that are
    not required on a system that users do not log into.

    To restore this content, you can run the 'unminimize' command.
    Last login: Mon Oct 17 11:59:38 2022 from 172.17.0.1
    $

If password is requested, see next chapter.

## passwords:

    root: foo
    oe:   foo

__Now the build can be started as usual.__

