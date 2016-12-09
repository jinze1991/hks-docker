#  hks-docker

```bash
    git clone https://github.com/jinze1991/hks-docker.git .
```

## use docker command build image and get setting file
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
    docker run -i -t -p 80:80 -p 9001:9001 -v <docker-machine-your-source-folder>:/home/web --name <your-container-name> httpd-php51:v0.1
```
5. Done. use docker build dev environment so very easy! <br>
Let's view container.
```bash
    docker ps -a
```
6. start container use docker command 
```bash
    docker start <your-container-name>
```
7. connect docker container we can use docker command `docker attach` 
```bash
    docker attach <your-container-name>
```