# docker-greenpau-pdu

Debian Docker image with Python 3.4, uWSGI 2.0, Django 1.7, and psycopg2. 

## Usage

Login to CoreOS AWS EC2 Instance:
```
ssh -i ~/.ssh/RSA_PRIVATE_KEY -p 22 core@AWS_EC2_PUBLIC_IP
```

Download the `greenpau/pdu` docker image:
```
docker pull greenpau/pdu
```

Run `aps1` application container using the following commands:
```
APS1_DOCKER_IMAGE=`docker images | grep greenpau/pdu | tr -s ' ' | cut -d" " -f3 | xargs`
docker stop $(docker ps -a | grep aps01 | tr -s ' ' | cut -d" " -f1 | xargs)
docker rm $(docker ps -a | grep aps1 | tr -s ' ' | cut -d" " -f1 | xargs)
docker run -d --name aps1 --hostname=aps1 -t ${APS1_DOCKER_IMAGE}
APS1_DOCKER_CONTAINER=`docker ps -a | grep greenpau/pdu | grep aps1 | tr -s ' ' | cut -d" " -f1 | xargs`
docker exec -i -t ${APS1_DOCKER_CONTAINER} cat /tmp/uwsgi_status.py
docker exec -d -t ${APS1_DOCKER_CONTAINER} uwsgi --http :9090 --wsgi-file /tmp/uwsgi_status.py
```

Validate the container is up and running from the host:
```
APS1_DOCKER_CONTAINER=`docker ps -a | grep greenpau/pdu | grep aps1 | tr -s ' ' | cut -d" " -f1 | xargs`
APS1_DOCKER_CONTAINER_IPV4=`docker exec -it ${APS1_DOCKER_CONTAINER} ip -f inet addr show dev eth0 | grep inet | sed 's/.*inet //;s/\/.*//' | xargs`
curl http://${APS1_DOCKER_CONTAINER_IPV4}:9090
```

The expected result is:
```
core@ip-172-31-24-111 ~ $ curl http://${APS1_DOCKER_CONTAINER_IPV4}:9090
uWSGI is up and running
core@ip-172-31-24-111 ~ $
```

Interact with the container:
```
APS1_DOCKER_CONTAINER=`docker ps -a | grep greenpau/pdu | grep aps1 | tr -s ' ' | cut -d" " -f1 | xargs`
docker exec -it ${APS1_DOCKER_CONTAINER} /bin/bash
```

When necessary, stop the container and delete it from the system:
```
APS1_DOCKER_IMAGE=`docker images | grep greenpau/pdu | tr -s ' ' | cut -d" " -f3 | xargs`
docker stop $(docker ps -a | grep aps1 | tr -s ' ' | cut -d" " -f1 | xargs)
docker rm $(docker ps -a | grep aps1 | tr -s ' ' | cut -d" " -f1 | xargs)
```

## Dockerfile

If a user is interested in building an image, the user may use or reference
[Dockerfile](https://raw.githubusercontent.com/greenpau/docker-greenpau-pdu/master/Dockerfile):

```
git clone https://github.com/greenpau/docker-greenpau-pdu.git
cd docker-greenpau-pdu
docker build --force-rm=true -t greenpau/pdu - < Dockerfile
```

If necessary to start with a clean sheet:
```
docker stop `docker ps -a | tr -s ' ' | cut -d" " -f1 | xargs`
docker rmi $(docker images | tr -s ' ' | cut -d" " -f3 | xargs)
docker images -a
```

## uWSGI

To restart the uWSGI, connect to the container and use the following commands:

```

```

The following are compilation options of `uWSGI`:

```
    ################# uWSGI configuration #################

    plugin_dir = .
    yaml = embedded
    filemonitor = inotify
    execinfo = False
    debug = False
    kernel = Linux
    zlib = True
    capabilities = True
    ifaddrs = True
    event = epoll
    pcre = True
    json = jansson
    xml = libxml2
    locking = pthread_mutex
    ssl = True
    malloc = libc
    routing = True
    timer = timerfd

    ############## end of uWSGI configuration #############

```

