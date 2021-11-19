Podman IN Docker images
=======================

Pind is a set of containerfiles for running podman using a Docker container.

Fedora
------

```
$ docker build -t pind-fedora - < Dockerfile.fedora
$ docker run -it --privileged --rm pind-fedora podman ps
```


A pre-built image is available from:

```
$ docker pull srbala/pind:latest
```


CentOS
------

```
$ docker build -t pind-centos - < Dockerfile.centos
$ docker run -it --privileged --rm pind-centos podman ps
```

Note: this image does currently not work as expected.
