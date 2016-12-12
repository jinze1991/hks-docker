#  hks-docker
## container image spec
centos 5.1.1 <br>
apache 2.2.3 <br> 
php 5.1.6 <br>
xdebug 2.0.0 <br>
- xdebug.idekey=1<br>
- xdebug.remote_port=9001<br>

port 80, 443, 9001 <br>
source root `/home/web/`
## if you not have `default` docker-machine. use it create a docker machine.
```bash
docker-machine create --driver virtualbox default
```
## connect your `default` docker-machine 
```bash
docker-machine ssh <machine-name>
```
## on your machine
```bash
git clone https://github.com/jinze1991/hks-docker.git
```

## use docker command build image and get `vhost.conf` file
1. download `vhost.conf` and copy to `<hks-docker-folder>`
2. move to `<hks-docker-folder>`
```bash
cd <hks-docker-folder>
```
3. build docker image
```bash
docker build -t httpd-php51:v0.1 -f Dockerfile .
```
4. run docker container with image`httpd-php51:v0.1`
```bash
docker run -i -t -p 80:80 -p 443:443 -p 9001:9001 -v <docker-machine-source-folder>:/home/web --name <container-name> httpd-php51:v0.1
```
5. Done. use docker build dev environment so very easy! <br>
Let's view container.
```bash
docker ps -a
```
6. start container use docker command 
```bash
docker start <container-name>
```
7. connect docker container we can use docker command `docker attach` 
```bash
docker attach <container-name>
```

<br><br>

mount docker-machine and your local share folder: <br>
on your docker-machine do this: 
```bash
sudo vi /var/lib/boot2docker/bootlocal.sh
```
`bootlocal.sh` file
```bash
#!/bin/sh
mkdir /home/web/
mkdir /home/hks-docker/
mount -t vboxsf web /home/web
mount -t vboxsf hks-docker /home/hks-docker
```
save and restart docker-machine
```bash
docker-machine restart <machine-name>
```