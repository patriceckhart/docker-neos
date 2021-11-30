## patriceckhart/docker-neos ##
Neos CMS 🐳 docker image based on Alpine linux with nginx + php-fpm 7.4 🚀, packing everything needed for development and production usage of Neos.

#### The image does a few things: ####
Automatically install and provision a Neos CMS website or a Neos Flow application, based on environment vars documented below. Pack a few useful things like git, redis, ...

### Usage ###
This image supports following environment variable for automatically configuring Neos at container startup:

#### Required env vars ####

| Docker env var | Description |
|---------|-------------|
|GITHUB_REPOSITORY|Link to Neos CMS website distribution|
|GITHUB_USERNAME|Will pull authorized keys allowed to connect to the container via ssh|

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
|NGINX_CLIENT_BODY_SIZE|Nginx client body size|
|PHP_TIMEZONE|PHP timezone|
|PHP_MEMORY_LIMIT|PHP memory limit|
|PHP_UPLOAD_MAX_FILESIZE|PHP upload maximum filesize|
|PHP_MAX_EXECUTION_TIME|PHP max execution time|
|PHP_MAX_INPUT_VARS|PHP max input vars|
|IMAGINE_DRIVER|Imagick|
|FLOW_CONTEXT|Development|

### Example docker-compose.yml configuration ###

```yaml
web:
  image: patriceckhart/docker-neos:7.4
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
    GITHUB_REPOSITORY_BRANCH: '7.2'
    SITE_PACKAGE: 'Raw.Site'
    RUN_DOCTRINE_MIGRATE: 1
    RUN_DOCTRINE_UPDATE: 1
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

In `/data/cron` there are folders named `1min`, `5min`, `15min`, `30min`, `hourly`, `daily`, `weekly` and `monthly`. Files can be stored in this folder in the following scheme: `100-backup`, `200-update`, `300-customname`, ...

#### Example `100-backup` in `/data/cron/daily` ####

```
#!/bin/sh

cd /data/neos && ./flow backup:create
```
Don't forget: `chmod 775 100-backup`

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
