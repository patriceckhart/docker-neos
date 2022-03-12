## patriceckhart/docker-neos ##
Neos CMS 🐳 docker image based on Alpine linux with nginx + php-fpm 8.0 🚀, packing everything needed for development and production usage of Neos.

#### The image does a few things: ####
Automatically install and provision a Neos CMS website or a Neos Flow application, based on environment vars documented below. Pack a few useful things like git, redis, ...

### Usage ###
This image supports following environment variable for automatically configuring Neos at container startup:

#### Required env vars ####

| Docker env var | Description |
|---------|-------------|
|GITHUB_REPOSITORY|Link to Neos CMS website distribution|
|GITHUB_USERNAME|Will pull authorized keys allowed to connect to the container via ssh|
|FLOW_CONTEXT|`Development` or `Production`|
|IMAGINE_DRIVER|`Imagick` or `Vips`|
|PHP_UPLOAD_MAX_FILESIZE|PHP upload maximum filesize eg. `10M`|
|PHP_MEMORY_LIMIT|PHP memory limit e.g. `512M`|
|NGINX_CLIENT_BODY_SIZE|Nginx client body size e.g. `512M`|

#### Optional env vars ####

| Docker env var | Description |
|---------|-------------|
|GITHUB_REPOSITORY_BRANCH|Github repository branch `optional`|
|GITHUB_TOKEN|Github Token for clone private repositories|
|DB_DATABASE|Database name, defaults to `neos`|
|DB_USER|Database user, defaults to `admin`|
|DB_PASS|Database password, defaults to `pass`|
|DB_HOST|Database host, defaults to `mariadb`|
|SITE_PACKAGE|Neos CMS website package is imported after installation|
|CONTAINERNAME|Container name for different processes around the container|
|VIRTUAL_HOST|Virtual host if a Nginx proxy is used|
|PERSISTENT_RESOURCES_FALLBACK_BASE_URI|`http://foo.bar` The live url to load locally unavailable resources|
|PHP_TIMEZONE|PHP timezone|
|PHP_MAX_EXECUTION_TIME|PHP max execution time|
|PHP_MAX_INPUT_VARS|PHP max input vars|
|RUN_DOCTRINE_MIGRATE|1|Run `./flow doctrine:migrate` at container start|
|RUN_DOCTRINE_UPDATE|1|Run `./flow doctrine:update` at container start|
|RUN_FLUSHCACHE|1|Run `./flow flow:cache:flush` and `./flow flow:cache:flush --force` at container start|
|RUN_STARTUP_SCRIPT|1|Run `startup.sh` after container start|

### Example docker-compose.yml configuration ###

```yaml
web:
  image: patriceckhart/docker-neos:8.0
  ports:
    - '80'
    - '22:22'
  links:
    - mariadb:mariadb
  volumes:
    - /data
  environment:
    CONTAINER_NAME: 'nameOfYourContainer'
    GITHUB_USERNAME: 'patriceckhart'
    GITHUB_TOKEN: 'yourgithubtoken'
    GITHUB_REPOSITORY: 'https://github.com/patriceckhart/NeosCMS-Boilerplate.git'
    GITHUB_REPOSITORY_BRANCH: '7.3'
    SITE_PACKAGE: 'Raw.Site'
    RUN_DOCTRINE_MIGRATE: 1
    RUN_DOCTRINE_UPDATE: 1
    RUN_FLUSHCACHE: 1
    DB_DATABASE: 'db'
    DB_USER: 'admin'
    DB_PASS: 'password'
    DB_HOST: 'db'
    NGINX_CLIENT_BODY_SIZE: '512M'
    PERSISTENT_RESOURCES_FALLBACK_BASE_URI: 'https://foobar.com'
    # a dev. subdomain automatically activates development mode
    VIRTUAL_HOST: dev.neos.local
    PHP_TIMEZONE: 'Europe/Berlin'
    PHP_MEMORY_LIMIT: '512M'
    PHP_UPLOAD_MAX_FILESIZE: '10M'
    PHP_MAX_EXECUTION_TIME: 240
    PHP_MAX_INPUT_VARS: 1500
    IMAGINE_DRIVER: 'Imagick'
    FLOW_CONTEXT: 'Development'
    
mariadb:
  image: mariadb:latest
  expose:
    - 3306
  volumes:
    - /var/lib/data
  environment:
    MYSQL_DATABASE: 'neos'
    MYSQL_USER: 'admin'
    MYSQL_PASSWORD: 'password'
    MYSQL_ROOT_PASSWORD: 'root'
  ports:
    - '3306:3306'
  command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

### Cronjobs ###

Now user-defined cron jobs can even be created easily. Simply create a folder called `cron`, another folder in the `cron` folder called `1min` and in this `1min` folder a file called `100-backup`, commit it to your project's root directory and deploy it.

This procedure works with the following folders: `1min`, `5min`, `15min`, `30min`, `hourly`, `daily`, `weekly` and `monthly`. Files can be stored in this folders in the following scheme: `100-backup`, `200-update`, `300-customname`, ...

#### Example `100-backup` ####

```
#!/bin/sh

cd /data/neos && ./flow backup:create
```

### SSH Access ###

For development you can ssh into the container:

`ssh www-data@yourvirtualhost.local -p <portnumber> -i ~/.ssh/yourPrivateSshKeyFile`

### Helpful cli scripts ### (usage: docker exec ... or kubectl exec ...)

| CLI command | Description |
|---------|-------------|
|flow|With `flow` you can execute `./flow` commands in every directory.|
|pullapp|Pulls latest code from git repository. `--force` runs additionally `doctrine:migrate`, `doctrine:update` and `node:repair`.|
|doctrinemigrate|Runs `doctrine:migrate`.|
|doctrineupdate|Runs `doctrine:update`.|
|flushcache|Flush all caches. `--removetempdir` removes the `Temporary` directory.|
|installneos|Runs `composer install`. `--force` runs additionally `doctrine:migrate`, `doctrine:update` and `node:repair`.|
|updateneos|Runs `composer update`. `--force` runs additionally `doctrine:migrate`, `doctrine:update` and `node:repair`.|
|noderepair|Runs `node:repair`. `--force` runs additionally `node:repair` without confirmation-|
|packagerescan|Runs `flow:package:rescan`.|
|silent `command`|Runs every command in background.|
