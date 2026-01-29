# v2ray-alpine
A backup image to start v2ray

![Docker Pulls](https://img.shields.io/docker/pulls/petermatthew/v2ray-alpine)
![Docker Image Size](https://img.shields.io/docker/image-size/petermatthew/v2ray-alpine)
![Docker Image Version](https://img.shields.io/docker/v/petermatthew/v2ray-alpine)

Build via Docker Compose, Source Repo: [v2ray-core](https://github.com/v2fly/v2ray-core/).

## Step 1
Clone this repo.
```bash
git clone https://github.com/WilliamPeterMatthew/v2ray-manager-alpine.git -b v2ray-alpine
```

## Step 2
Place your `config.json` in the directory.

## Step 3
Modify or keep the ports in `docker-compose.yml` file (use `docker-compose-prebuild.yml` file if you want to use a pre-build version of the image instead of building locally) .

## Step 4
Run the project by executing the following command in the directory.
```bash
docker-compose up -d
```

You can also use a pre-built version of the image instead of building locally.
```bash
docker-compose -f docker-compose-prebuild.yml up -d
```

## Congratulations
Now you can access the server on the port you set in Step 3.